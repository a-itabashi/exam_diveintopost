class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  # Agendaを削除できるのは、user_id(Agendaの作者)もしくはteam_id(チームの作者)
  before_action :allowed_only_user_or_owner, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def show
    @agenda = Agenda.find(params[:id])
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    @agenda.destroy
    # 通知メールの送信
    redirect_to dashboard_url
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def allowed_only_user_or_owner
    @agenda = Agenda.find(params[:id])
    @team = Team.find_by(owner_id: current_user.id)
    unless current_user.id == @agenda.user_id || @team.owner_id == @agenda.team_id
      redirect_to dashboard_url, notice: '権限がありません'
    end
  end
end
