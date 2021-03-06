class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :load_checkin

  # GET /groups
  # GET /groups.json
  def index
    @groups = @checkin.groups.all
    current_user.group_id=nil
    current_user.save

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    current_user.checkin_id, current_user.group_id = params[:checkin_id], params[:id]
    current_user.save
    @user=current_user
    @grouping_table = @group.grouping_table.new
    @grouping_table.user_id=current_user.id
    @grouping_table.checkin_id=@checkin.id

    find_user
  end

  # GET /groups/new
  def new

    @group = @checkin.groups.new
    @group.user_id=current_user.id

  end


  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = @checkin.groups.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to [@checkin, @group], notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to [@checkin ,@group], notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to checkin_groups_path(@checkin), notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def load_checkin
      @checkin = Checkin.find(params[:checkin_id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit( :user_id, :group_name, :checkin_id)
    end

    def find_user
      @grouping_tables=GroupingTable.where(group_id: params[:id], checkin_id: params[:checkin_id])
      @users = Array.new
      @grouping_tables.each do |group|
        user = User.find(group.user_id)
        @users<<user
      end
    end
end
