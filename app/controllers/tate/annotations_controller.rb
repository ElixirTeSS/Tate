module Tate

class AnnotationsController < ApplicationController

  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy, :create_multiple ]

  before_filter :find_annotation, :only => [ :show, :edit, :update, :destroy ]
  before_filter :find_annotatable, :except => [ :show, :edit, :update, :destroy ]
  before_filter :authorise_action, :only =>  [ :edit, :update, :destroy ]

  # GET /annotations
  # GET /annotations.xml
  def index
    params[:num] ||= 50

    @annotations =
        if @annotatable.nil?
          Tate::Annotation.all
        else
          @annotatable.latest_annotations(params[:num])
        end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annotations }
    end
  end

  # GET /annotations/1
  # GET /annotations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annotation }
    end
  end

  # GET /annotations/new
  # GET /annotations/new.xml
  def new
    @annotation = Tate::Annotation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @annotation }
    end
  end

  # POST /annotations
  # POST /annotations.xml
  def create
    parameters = get_annotation_params(params)

    if parameters[:source_type].blank? and parameters[:source_id].blank?
      if logged_in?
        parameters[:source_type] = current_user.name
        parameters[:source_id] = current_user.id
      end
    end
    @annotation = Tate::Annotation.new(:attribute_name => parameters[:attribute_],
                                       :value => parameters[:value],
                                       :source_type => parameters[:source_type],
                                       :source_id => parameters[:source_id],
                                       :annotatable_type => parameters[:annotatable_type],
                                       :annotatable_id => parameters[:annotatable_id])

    respond_to do |format|
      if @annotation.save!
        flash[:notice] = 'Annotation was successfully created.'
        format.html { redirect_to :back }
        format.xml  { render :xml => @annotation, :status => :created, :location => @annotation }
      else
        flash[:error] = 'Annotation could not be added'
        format.html { redirect_to @annotation  }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /annotations/create_multiple
  # POST /annotations/create_multiple.xml
  def create_multiple
    if params[:annotation][:source_type].blank? and params[:annotation][:source_id].blank?
      if logged_in?
        params[:annotation][:source_type] = current_user.class.name
        params[:annotation][:source_id] = current_user.id
      end
    end

    success, annotations, errors = Tate::Annotation.create_multiple(params[:annotation], params[:separator])

    respond_to do |format|
      if success
        flash[:notice] = 'Annotations were successfully created.'
        format.html { redirect_to :back }
        format.xml  { render :xml => annotations, :status => :created, :location => @annotatable }
      else
        flash[:error] = 'Some or all annotations failed to be created.'
        format.html { redirect_to :back }
        format.xml  { render :xml => annotations + errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /annotations/1/edit
  def edit
  end

  # PUT /annotations/1
  # PUT /annotations/1.xml
  def update
    @annotation.value = params[:annotation][:value]
    @annotation.version_creator_id = current_user.id
    respond_to do |format|
      if @annotation.save
        flash[:notice] = 'Annotation was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @annotation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1
  # DELETE /annotations/1.xml
  def destroy
    @annotation.destroy

    respond_to do |format|
      flash[:notice] = 'Annotation successfully deleted.'
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  private

  def get_annotation_params(params)
    params.require(:annotation).permit(:annotatable_id, :annotatable_type,
                                       :source_id, :source_type, :user,
                                       :text_value, :text, :value, :annotation, :attribute_)
  end

  protected

  def find_annotation
    @annotation = Tate::Annotation.find(params[:id])
  end

  def find_annotatable
    puts params
    @annotatable = nil

    if params[:annotation]
      @annotatable = Tate::Annotation.find_annotatable(params[:annotation][:annotatable_type], params[:annotation][:annotatable_id])
    end

    # If still nil try again with alternative params
    if @annotatable.nil?
      @annotatable = Tate::Annotation.find_annotatable(params[:annotatable_type], params[:annotatable_id])
    end
  end

  # Currently only checks that the source of the annotation matches the current user
  def authorise_action
    if !logged_in? or (@annotation.source != current_user)
      # TODO: return either a 401 or 403 depending on authentication
      respond_to do |format|
        flash[:error] = 'You are not allowed to perform this action.'
        format.html { redirect_to :back }
        format.xml  { head :forbidden }
      end
      return false
    end
    return true
  end
end
end
