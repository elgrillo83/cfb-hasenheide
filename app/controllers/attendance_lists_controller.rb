class AttendanceListsController < ApplicationController
  before_action :set_attendance_list, only: %i(close close_mail open open_mail)

  def show
    @event = Event.friendly.find(params[:event_id])
    @attendance_list = @event.attendance_list

    if @attendance_list.nil?
      redirect_to event_path(@event), alert: 'Meldeliste nicht vorhanden!'
      return
    end

    @current_user_attendance =
      @attendance_list.attendances.find_by(player_id: current_user.player.id)
  end

  def close
    if @attendance_list.close!
      deliver_attendance_list_closed_mail if params[:mail]
      flash[:notice] = 'Meldeliste wurde erfolgreich geschlossen.'
    else
      flash[:alert] = 'Meldeliste konnte nicht geschlossen werden.'
    end

    redirect_to event_attendance_list_path(@attendance_list.attendable_id)
  end

  def close_mail
    @attending_players = @attendance_list.attendable.attending_players
    @all_players = Player.order(:nickname)
  end

  def open_mail
    @eligible_players = @attendance_list.attendable.eligible_players
    @all_players = Player.order(:nickname)
  end

  def open
    if @attendance_list.open!
      deliver_attendance_list_opened_mail if params[:mail]
      flash[:notice] = 'Meldeliste wurde erfolgreich geöffnet.'
    else
      flash[:alert] = 'Meldeliste konnte nicht geöffnet werden.'
    end

    redirect_to event_attendance_list_path(@attendance_list.attendable_id)
  end

  private

  def deliver_attendance_list_closed_mail
    EventMailer.attendance_list_closed(@attendance_list.attendable_id,
                                       to_player_ids: params[:player_ids],
                                       message: params[:message],
                                       from_user_id: current_user.id)
               .deliver_later

    flash[:notice] += ' Final Call wurde versendet.'
  end

  def deliver_attendance_list_opened_mail
    EventMailer.attendance_list_opened(@attendance_list.attendable_id,
                                       to_player_ids: params[:player_ids],
                                       message: params[:message],
                                       from_user_id: current_user.id)
               .deliver_later

    flash[:notice] += ' Mail wurde versendet.'
  end

  def set_attendance_list
    @attendance_list = AttendanceList.find(params[:id])
  end
end
