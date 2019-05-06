class TeamMailer < ApplicationMailer
  def team_mail(team)
    @team = team

    mail to: "#{@team.owner.email}", subject: "権限移動の手続き完了のお知らせ"
  end
end
