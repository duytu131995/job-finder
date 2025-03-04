class ResumesController < ApplicationController
  before_action :load_resume, except: %i(index new create)
  before_action :check_resume_number, only: %i(new create)

  def index
    @resumes = current_user.resumes
  end

  def new
    @resume = current_user.resumes.build.tap do |r|
      r.add_ons.build
      r.resume_skills.build
    end
    @skills = Skill.pluck :name, :id
  end

  def create
    @resume = current_user.resumes.build resume_params
    if @resume.save
      flash[:success] = t "create success"
      redirect_to resumes_path
    else
      flash.now[:danger] = t "create fail"
      render :new
    end
  end

  def show; end

  def edit
    @skills = @resume.skills.pluck :name, :id
  end

  def update
    if @resume.update resume_params
      flash[:success] = "Update resume success"
      redirect_to resumes_path
    else
      flash[:danger] = "Update resume false"
      redirect_to resumes_path
    end
  end

  def destroy
    if @resume.destroy
      flash[:success] = t "destroy success"
      redirect_to resumes_path
    else
      flash.now[:danger] = t "destroy fail"
      redirect_to resumes_path
    end
  end

  private

  def resume_params
    params.require(:resume).permit(Resume::RESUME_PERMIT)
  end

  def load_resume
    @resume = Resume.find_by id: params[:id]
    return if @resume.present?

    flash[:danger] = "Not found resume"
  end

  def check_resume_number
    return if current_user.resumes.count < 2

    flash[:danger] = "You only create 2 resume"
    redirect_to resumes_path
  end
end
