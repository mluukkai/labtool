class FeedbackCommentsController < ApplicationController
  skip_before_filter :authenticate, only: [:create]

  def create
    expire_fragment('current_course')

    params[:feedback_comment]['text'] = params[:feedback_comment]['text'].lstrip.rstrip
    @feedback = WeekFeedback.find(params[:week_feedback])
    @user = User.find_by_student_number(session[:student_number])

    comment = FeedbackComment.new(params[:feedback_comment])
    comment.user = @user

    @feedback.feedback_comments << comment

    student = @user
    reviewer = @feedback.giver
    NotificationMailer.email(reviewer.email, reviewer.email, "Palautettasi on kommentoitu\nks. #{user_url student}", "viikon #{@feedback.week} palaute", params['notify-cc'], Course.active.name).deliver

    redirect_to "/mypage/#{@user.student_number}", :notice => "Comment was successfully created."
  end

  def create_admin_reply
    expire_fragment('current_course')
    #expire_action :controller => 'courses', :action => 'show', :id => Course.active.id

    params[:feedback_comment]['text'] = params[:feedback_comment]['text'].lstrip.rstrip
    @feedback = WeekFeedback.find(params[:week_feedback])

    comment = FeedbackComment.new(params[:feedback_comment])
    comment.user = current_user

    @feedback.feedback_comments << comment

    if params[:notify]
      student = @feedback.user
      reviewer = current_user
      NotificationMailer.email(reviewer.email, student.email, "Palautettasi on kommentoitu\nks. #{mypage_url+'/'+student.student_number}", "viikon #{@feedback.week} palaute", params['notify-cc'], Course.active.name).deliver
    end

    redirect_to @feedback.registration.user, :notice => 'Comment was successfully created.'

  end

end
