class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda)
    @agenda = agenda

    @users = @agenda.team.members
    @users.each do |user|
      mail to:  "#{user.email}" , subject: "アジェンダが削除されました"
    end
  end
end
