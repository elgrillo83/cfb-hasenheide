class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update]

  respond_to :html

  def index
    @reports = Report.all.page(params[:page])
  end

  def show
    @report = Report.where(event_id: params[:event_id]).first

    redirect_to(action: :new) && return unless @report.present?
  end

  def new
    @report = Report.new(event_id: params[:event_id])
  end

  def create
    @report = Report.new(report_params)
    flash[:notice] = 'Bericht wurde erfolgreich erstellt.' if @report.save

    respond_with @report, location: reports_path
  end

  def edit
  end

  def update
    if @report.update(report_params)
      flash[:notice] = 'Bericht wurde erfolgreich aktualisiert.'
    end

    respond_with @report, location: reports_path
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:event_id, :content, :club_final_score,
                                   :rival_final_score, :club_half_time_score,
                                   :rival_half_time_score)
  end
end
