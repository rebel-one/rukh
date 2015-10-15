# -*- encoding : utf-8 -*-
class ImportController < ApplicationController
  before_action :authenticate_user! ## for DEVISE
  
  ## External GEMs
  require 'cmess/guess_encoding' #Should be on Import Logic
  
  ## Internal libraries
  require 'ImportLogic'
  # include  ImportLogic
  
  ## Methods
  def new
    @import_title = "Importar"
  end
  
  def create
    file = params[:file]
    begin
      if file.blank?
        flash[:error] = "Ningún file selecionado."
        redirect_to action: 'new', status: 303 
      elsif file.headers['Content-Type: text/csv'] or 
          file.headers['Content-Type: application/vnd.ms-excel']
        updater = ProgressBarUpdater.new
        importer = ImportLogic.new(updater)
        result = importer.import_csv(file)
        importer.terminate
        # updater.terminate
        
        flash[:notice] = result
        redirect_to debts_path
      else
        flash[:error] = "No es un CSV"
        flash[:notice] = file.headers
        redirect_to action: 'new', status: 303   
      end
    end
  end
  
  
end
