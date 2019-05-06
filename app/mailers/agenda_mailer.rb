class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda)
    @agenda = agenda

    @users = @agenda.team.members
    mail to: @users.map{|u| u.email}
    mail subject: "アジェンダが削除されました"  


    # @users.each do |user|
    #   mail to:  "#{user.email}" , 
    #   subject: "アジェンダが削除されました"
    # end
  end
end
