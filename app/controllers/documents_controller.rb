class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :create_new_tag]
  before_action :set_tag, only: [:edit, :create_new_tag]

  # GET /documents
  # GET /documents.json
  def index
    @right_menu_mode = :search
    @search_document = Document.new

    @search_param_tag_ids = []
    if not params[:document].nil?
      @search_param_tag_ids = params[:document][:tag_ids].reject(&:blank?)
    else
      if not session[:document_search_filter].nil?
        @search_param_tag_ids = session[:document_search_filter]
      end
    end

    if @search_param_tag_ids.count == 0
      all_documents = Document.by_received_date
      @documents_count = all_documents.count
      @documents = documents_by_month(all_documents)

      session[:document_search_filter] = nil
    else
      all_documents = Document.filter_by_tag_ids(@search_param_tag_ids)
      @documents_count = all_documents.count
      @documents = documents_by_month(all_documents)
      session[:document_search_filter] = @search_param_tag_ids
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end


  # POST /documents/create_from_camera
  # POST /documents/create_from_camera.json
  def create_from_camera
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    respond_to do |format|
      if @document.save
        format.html { redirect_to edit_document_path(@document), notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_new_tag
    tag = Tag.create tag_params

    respond_to do |format|
      if @document.save
        format.html { redirect_to edit_document_path(@document), notice: 'Tag was successfully added.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    local_document_params = document_params.dup
    local_document_params[:tags] .reject! { |c| c.empty? }

    tag_ids_to_remove = tag_ids_to_add = []

    if @document.tags
      existing_tag_ids = @document.tags.pluck(:id)
      puts "<--"
      puts existing_tag_ids
      puts "-->"
      tag_ids_to_remove = existing_tag_ids - local_document_params[:tags]
      tag_ids_to_add = local_document_params[:tags] - existing_tag_ids

      puts tag_ids_to_remove
      puts tag_ids_to_add

      # remove :tags param for ORM
      local_document_params.delete(:tags)
    end

    ActiveRecord::Base.transaction do
      tag_ids_to_remove.each do |tag_id|
        @document.tags.delete tag_id
      end

      tag_ids_to_add.each do |tag_id|
        @document.tags << Tag.find(tag_id)
      end

      @document.save!

      respond_to do |format|
        if @document.update(local_document_params)
          format.html { redirect_to edit_document_path(@document), notice: 'Document was successfully updated.' }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def documents_by_month(all_documents)
      documents_by_month = {}
      all_documents.each do |document|
        if document.received_at != nil
          actual_month = document.received_at.beginning_of_month
        else
          actual_month = document.created_at.beginning_of_month
        end
        documents_by_month[actual_month] = [] if not documents_by_month[actual_month].kind_of?(Array)
        documents_by_month[actual_month] << document
      end
      documents_by_month
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      puts "<--"
      puts params
      puts "-->"
      params.require(:document).permit(:attachment, tags: []) if params[:document]
    end

    def set_tag
      @tag = Tag.new
    end

    def tag_params
      params.require(:tag).permit(:name, :color, :icon)
    end
end
