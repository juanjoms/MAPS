class CompaniesController < ApplicationController
  before_action :authenticate_user!

  # GET /companies
  def index
    @companies = Company.all()
  end

  def show
    @company = Company.find(params[:id])
  end


  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])    
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company
      flash[:notice] = "Organización creada correctamente"
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name, :description)
  end
end
