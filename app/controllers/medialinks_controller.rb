class MedialinksController < ApplicationController

  before_filter :fetch_profile_from_params
  before_filter :ensure_own_medialinks

  def index
    @medialinks = @profile.medialinks.order(:created_at)
  end

  def new
    @medialink = Medialink.new(url: 'http://')
  end

  def edit
    @medialink = @profile.medialinks.find(params[:id])
  end

  def update
    @medialink = @profile.medialinks.find(params[:id])
    if @medialink.update_attributes(params[:medialink])
      # TODO translation flash
      redirect_to profile_medialinks_path(@profile), notice: (I18n.t("flash.medialink.updated"))
    else
      render action: "edit"
    end
  end

  def destroy
    @medialink = @profile.medialinks.find(params[:id])
    @medialink.destroy
      # TODO translation flash
    redirect_to profile_medialinks_path(@profile), notice: (I18n.t("flash.medialink.destroyed"))
  end

  def create
    @medialink = @profile.medialinks.build(params[:medialink])
    if @medialink.save
      # TODO translation flash
      flash[:notice] = (I18n.t("flash.medialink.created"))
      redirect_to profile_medialinks_path(@profile)
    else
      # TODO translation flash
      flash[:notice] = (I18n.t("flash.medialink.error"))
      render action: "new"
    end
  end

  protected

  def fetch_profile_from_params
    @profile = Profile.find(params[:profile_id])
  end

  def ensure_own_medialinks
    if @profile != current_profile
      redirect_to root_path, notice: 'Sorry, but you can not edit other peoples medialinks. OK?'
    end
  end
end
