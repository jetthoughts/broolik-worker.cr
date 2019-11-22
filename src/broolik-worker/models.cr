class URL < Granite::Base
  connection pg

  table urls

  column id : Int64, primary: true
  column url : String
  column response_http_status : String?
  column processed : Bool? = false
  column success : Bool? = true
  column processing_time : Int64?

  timestamps
end
