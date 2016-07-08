class VendorMailer < ActionMailer::Base
  default from: "info@gionee.co.in"

  def requestApproved(request)
    @request = request
    email = User.find_users('vendor allocator').pluck(:email)
    mail(to: email,cc: DEFAULT_EMAILS, subject: 'Vendor Assignment Reminder')
  end

  def vendorVerify(request)
    @request = request
    email = Role.findRRMEmail(request)
    mail(to: email,cc: DEFAULT_EMAILS, subject: 'Vendor Assignment Verify')
    #rrm vendor akash
  end

  def vendorAllocatorAssignment(request_id,user_id)
    @request = Request.find(request_id)
    @user = User.find(user_id)
    emailCC = Role.findRRMEmail(@request)
    email = @user.email
    mail(to: email,cc: DEFAULT_EMAILS+[emailCC], subject: 'Vendor Assignment')
  end

  def vendorReplace(request)
    @request = request
    email = request.request_assignment.user.email
    emailCC = Role.findRRMEmail(request)
    mail(to: DEFAULT_EMAILS,cc: [emailCC]+DEFAULT_EMAILS, subject: 'Vendor Reassignment')
    #newVendor RRM akash
  end

  def vendorResponse(request,status)
    @request = request
    @status = status
    emailRRM = Role.findRRMEmail(request)
    emailVA  = User.find_users('vendor allocator').pluck(:email)
    mail(to: [emailRRM]+emailVA,cc: DEFAULT_EMAILS, subject: 'Vendor Action')
    #RRM vendorAllocator akash
  end

  def vendorDocumentsUpload(request)
    @request = request
    @status = status
    emailRRM = Role.findRRMEmail(request)
    emailVA  = User.find_users('vendor allocator').pluck(:email)
    mail(to: [emailRRM]+emailVA,cc: DEFAULT_EMAILS, subject: 'Upload Documents by Vendor')
    #RRM vendorAllocator akash
  end

  def vendorAssignmentResponse
    #if responseByCMO then RRM vendorAllocator akash
    #if responseByRRM then CMO vendorAllocator akash
  end


end
