#1. We have main company module 
#2. We are validating and saving only one sub node i.e. user node
#3. If we use @Company.update_attributes(params[:company]) it will validate all the nodes of company module
#4. Hence we are validating it sepeartely and assigning error(if any) to main node

def updateCompanyUser
    
    @company = Company.find(params[:id])    
    insID = ""
    #posted data    
    params[:company][:user_attributes].values.each do |attr_name|          
      insID = attr_name[:id]      
    end    

    if params[:company][:user_attributes]
        #create new object of user if not present
        user = @company.use.find_or_initialize_by(:_id => insID)          
        user.attributes = params[:company][:user_attributes].values[0] 
        #validate user
        if user.valid?           
          if @company.save_without_validation            
            flash[:notice] =  "Your details have been updated"
            redirect_to profile_path, :success => "Your details have been saved"
          end
        else 
          #Iterate error message of sub node i.e. user and append it to base of main node i.e. company
          user.errors.full_messages.each do |msg|                      
           @company.errors[:base] << msg
          end          
        end
    end 
  end
