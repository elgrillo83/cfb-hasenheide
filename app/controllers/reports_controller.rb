class ReportsController < ApplicationController
  before_action :set_event, only: [:new, :edit]
  before_action :set_report, only: [:show, :edit, :update]

  respond_to :html

  def index
    @reports = Report.joins(:event)
                     .order('events.datetime DESC')
                     .page(params[:page])
  end

  def no_content
    @reports = Report.no_content
                     .joins(:event)
                     .order('events.datetime DESC')
                     .page(params[:page])
  end

  def missing
    @events_without_report = Event.past.without_report.page(params[:page])
  end

  def show
    @event = @report.event
    @attending_players =
      Player.where(id: @event.attendances.yes.pluck(:player_id)).order(:nickname)
    @watching_players =
      Player.where(id: @event.attendances.watch.pluck(:player_id)).order(:nickname)

    if @report.nil? && current_user.admin?
      redirect_to new_report_path(event_id: @event.id)
    elsif @report.nil?
      redirect_to event_path(@event), alert: 'Spielbericht nicht vorhanden!'
      return
    end
  end

  def new
    @report = @event.build_report
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to event_report_path(@report.event_id),
                  notice: 'Bericht wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @report.update(report_params)
      redirect_to event_report_path(@report.event_id),
                  notice: 'Bericht wurde erfolgreich aktualisiert.'
    else
      render 'edit'
    end
  end

  private

  def set_event
    @event = Event.friendly.find(params[:event_id])
  end

  def set_report
    if params[:id].present?
      @report = Report.find(params[:id])
    elsif params[:event_id].present?
      @report = Event.friendly.find(params[:event_id]).report
    else
      raise StandardError,
            'Neither :id nor :event_id param given to find report!'
    end
  end

  def report_params
    params.require(:report).permit(:annotation,
                                   :captain_id,
                                   :club_final_score,
                                   :club_half_time_score,
                                   :content,
                                   :corners_club,
                                   :corners_rival,
                                   :event_id,
                                   :goalkeeper_id,
                                   :incident,
                                   :most_valuable_player_id,
                                   :possession,
                                   :referee,
                                   :referee_description,
                                   :referee_name,
                                   :reporter_id,
                                   :rival_final_score,
                                   :rival_half_time_score,
                                   :turf,
                                   :weather)
  end
end
