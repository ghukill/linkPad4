# OpenURI
require 'open-uri'



class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    # configs
    @splash_host = '68.42.117.7:8050'

    @link = Link.new(link_params)
    
    # hit Splash and get HTML
    url_string = "http://#{@splash_host}/render.html?url=#{link_params['URL']}&wait=1"
    rendered_html =  open(url_string).read
    @link.html = rendered_html

    
    # hit Splash and get thumbnail
    url_string = "http://#{@splash_host}/render.png?url=#{link_params['URL']}&wait=1&width=320&height=240"
    # retrieve URL, save to temp file
    md5 = Digest::MD5.new
    md5.update link_params['URL']
    temp_filename = md5.hexdigest

    File.open("/tmp/#{temp_filename}", "wb") do |saved_file|
      # the following "open" is provided by open-uri
      open(url_string, "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end

    # set to Link handle and delete temp file
    # @link.screenshot = File.open("/tmp/#{temp_filename}", 'rb') {|file| file.read }
    # File.delete("/tmp/#{temp_filename}")


    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/168.42.117.7:8050
  # PATCH/PUT /links/1.json
  def update
    puts link_params
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /books/search
  # GET /books/search.json
  def search
    @links = Link.search do
      keywords params[:query]
    end.results

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render :json => @links }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      # params.require(:link).permit(:title, :URL, :html, :query, :screenshot)
      params.require(:link).permit(:URL)
    end

end
