class FriendsController < ApplicationController
  load_and_authorize_resource
  before_action :set_friend, only: [:show, :edit, :update]

  # GET /friends
  def index
    @friends = Friend.where(:authenticated => false, :register_ip => my_ip)
  end

  # GET /friends/1
  def show
    @friend = Friend.find(params[:id])
    if @friend.register_ip!=my_ip \
      or (Time.parse(DateTime.now.to_s) - Time.parse(@friend.created_at.to_s))/3600 > 2
      redirect_to new_friend_path
    end
  end

  # GET /friends/new
  def new
    @friend = Friend.new
    @my_ip =  my_ip
  end

  # GET /friends/1/edit
  def edit
    if @friend.register_ip!=my_ip \
      or (Time.parse(DateTime.now.to_s) - Time.parse(@friend.created_at.to_s))/3600 > 2
      redirect_to new_friend_path
    end
  end

  # POST /friends
  def create
    if params[:friend][:unknown_year]
      params[:friend]["birthday(1i)"]=1900.to_s
    end

    @friend = Friend.new(friend_params)
    @friend.user = current_user unless current_user.nil?
    @friend.save ? (redirect_to friend_path(@friend), notice: '谢谢！您的信息已被保存.') : (render :new)
  end

  # PATCH/PUT /friends/1
  def update
    @friend.update(friend_params) ? (redirect_to friend_path(@friend), notice: '信息更新成功！') : (render :edit)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def friend_params
    params.require(:friend).permit(
        :name,
        :gender,
        :telephone,
        :mobile,
        :email,
        :wechat,
        :birthday,
        :unknown_year,
        :come,
        :job,
        :find_us,
        :find_us_additional,
        :pray,
        :comment,
        :register_ip,
        :user_id,
        :participated_gathering_ids => []
    )
  end
end
