class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    search = params[:search]
    render :json => json_for_autocomplete(Tag.where('name LIKE ?', "%#{search}%"), 'name', [
      'created_at'
    ])
  end

  #
  # Returns a hash with three keys actually used by the Autocomplete jQuery-ui
  # Can be overriden to show whatever you like
  # Hash also includes a key/value pair for each method in extra_data
  #
  def json_for_autocomplete(items, method, extra_data=[])
    items.collect do |item|
      hash = {"id" => item.id.to_s, "label" => item.send(method), "value" => item.send(method), "icon" => item.icon }
      extra_data.each do |datum|
        hash[datum] = item.send(datum)
      end if extra_data
      # TODO: Come back to remove this if clause when test suite is better
      hash
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name, :color, :icon)
    end
end
