class URL < Granite::Base
  connection pg

  table urls
  column id : Int64, primary: true
  column url : String
  column last_response_status : String?
  column processed : Bool = false
  column processed : Bool = false
  timestamps
end
