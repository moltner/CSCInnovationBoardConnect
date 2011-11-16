require 'rubygems'
require 'savon'
require 'hashie'
require 'json'

class AccountAdapter < SourceAdapter
  def initialize(source) 
    super(source)
  end
 
  def login
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)
    client = Savon::Client.new do
      wsdl.document = "http://erp.esworkplace.sap.com/sap/bc/srt/wsdl/bndg_DF530386F51A60F18F0400145E5ADE89/wsdl11/allinone/standard/document?sap-client=800"
      http.auth.basic("P1144646", "9431Moldina526")
    end  

    requestString = 
             "<CustomerSelectionByNameAndAddress>
                <Common>
                   <Name>
                      <FirstLineName></FirstLineName>
                      <SecondLineName>Becker</SecondLineName>
                   </Name>
                </Common>
             </CustomerSelectionByNameAndAddress>
             <ProcessingConditions/>"
             
    response = client.request(
      "glob", 
      "CustomerERPAddressBasicDataByNameAndAddressQuery_sync") {soap.body = requestString}
      
    mash = Hashie::Mash.new(response.to_hash)
    @result = {}
    mash.customer_erp_address_basic_data_by_name_and_address_response_sync.customer.each { |customer|
      entry = {}
      entry["customerId"] = customer.id if customer.id?
      nameHash = customer.common.name
      entry["firstLineName"] = nameHash.first_line_name if nameHash.first_line_name? 
      entry["secondLineName"] = nameHash.second_line_name if nameHash.second_line_name?
      address = customer.address_information.address.physical_address
      entry = entry.merge(address.to_hash)
      @result[entry["customerId"]] = entry
    }
    p @result
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    # TODO: Create a new record in your backend data source
    raise "Please provide some code to create a single record in the backend data source using the create_hash"
  end
 
  def update(update_hash)
    # TODO: Update an existing record in your backend data source
    raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def delete(delete_hash)
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end