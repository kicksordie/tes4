class TeachersController < ApplicationController
  # GET /teachers
  # GET /teachers.json
  def index
    @user = @current_user
    @searchvalue
    @teachers = []
   
    if params[:teacher]
      @searchvalue = params[:teacher]
      params[:teacher].split(" ").each do |name|
        @teachers+=Teacher.search(name).all
      end
      @teachers.uniq! { |t| t.id }
    end

    if params[:letter]
        @searchvalue = params[:letter]
        @teachers+=Teacher.searchletter(params[:letter]).all
    end



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teachers }
    end
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
    @user = @current_user
    @teacher = Teacher.find(params[:id])


    @orgrating = ((@teacher.ratings.average(:org1)+
                    @teacher.ratings.average(:org2)+
                    @teacher.ratings.average(:org3))/3)

        @comrating = ((@teacher.ratings.average(:com1)+
                    @teacher.ratings.average(:com2)+
                    @teacher.ratings.average(:com3))/3)

            @diffrating = ((@teacher.ratings.average(:diff1)+
                    @teacher.ratings.average(:diff2)+
                    @teacher.ratings.average(:diff3))/3)

          @globalrating = (@orgrating+@comrating+(5-@diffrating))/3





    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @teacher }
    end
  end

  # GET /teachers/new
  # GET /teachers/new.json
  def new
    @user = @current_user
    @teacher = Teacher.new(params[:employment])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @teacher }
    end
  end

  # GET /teachers/1/edit
  def edit
    @teacher = Teacher.find(params[:id])
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(params[:teacher])
    respond_to do |format|
      if @teacher.save
        Employment.create(:teacher_id => @teacher[:id], :school_id => params[:employment][:school_id])
        format.html { redirect_to teachers_path(:teacher => @teacher.last_name), notice: 'Teacher was successfully created.' }
        format.json { render json: @teacher, status: :created, location: @teacher }
      else
        format.html { render action: "new" }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teachers/1
  # PUT /teachers/1.json
  def update
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy

    respond_to do |format|
      format.html { redirect_to teachers_url }
      format.json { head :no_content }
    end
  end
end
