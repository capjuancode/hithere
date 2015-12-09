class PagesController < ApplicationController
  def home
    current_user.group_id=nil
    current_user.checkin_id=nil
    current_user.save
  end

  def groups
    @groups=GroupingTable.all

    current_user.group_id=nil
    current_user.checkin_id=nil
    current_user.save
  end  
end
