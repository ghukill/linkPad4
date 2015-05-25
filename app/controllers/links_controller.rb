# OpenURI
require 'open-uri'



class LinksController < ApplicationController
  
  # skip authenticity
  skip_before_filter :verify_authenticity_token

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

    # print params
    puts link_params
    
    # hit Splash and get HTML
    url_string = "http://#{@splash_host}/render.html?url=#{link_params['URL']}&wait=1"
    rendered_html =  open(url_string).read
    @link.html = rendered_html

    # load into Nokogiri and extract title
    parsed_html = Nokogiri::HTML(rendered_html)
    title = parsed_html.css('title').text
    if title == ""
      @link.title = "Unknown Title"
    else
      @link.title = title
    end
    
    # hit Splash and get thumbnail
    url_string = "http://#{@splash_host}/render.png?url=#{link_params['URL']}&wait=1&width=320&height=240"
    @link.picture_from_url(url_string)


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


  # POST /links/create_raw
  # POST /links/create_raw.json
  def create_raw

    @link = Link.new(link_params)

    # print params
    puts link_params
    
    # retrieve thumbnail from URL
    @link.picture_from_url(link_params['screenshot'])

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
      params.require(:link).permit(:title, :URL, :html, :screenshot)
    end

end
