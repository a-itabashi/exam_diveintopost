class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]

  before_action :allow_only_owner, only: %i[edit update]

  before_action :change_admin, only: %I[change_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'チーム更新に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_owner
    @team = Team.find(params[:format])
    @team.owner_id = params[:assign]
    if @team.update(team_params)
      # 権限移動の完了メールを送付
      TeamMailer.team_mail(@team).deliver
      redirect_to team_path(@team), notice: 'オーナを更新しました！'
    else
      redirect_to team_path(@team), notice: '更新に失敗しました'
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id :assign]
  end


  def allow_only_owner
    @team = Team.friendly.find(params[:id])

  def change_admin
    @team = Team.find(params[:format])

    unless current_user.id == @team.owner_id
      redirect_to team_path(@team), notice: '権限がありません'
    end
  end

end
