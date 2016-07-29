class SalesOrder < ActiveRecord::Base
  require "spreadsheet/excel" 

  has_one :shop_dimension
  has_one :catchment
  has_one :shop_ownership
  has_many :parteners
  has_many :bizs
  has_many :industries
  has_many :competitions
  has_many :pictures, :as => :object, :dependent => :destroy



  def self.create(params)
    
    sales_order = SalesOrder.new(name: params[:name],
        email: params[:email],
        phone: params[:mobile],
        state_id: params[:state]
      )
        begin
          if sales_order.save
          shop_dimensions(params,sales_order)
          catchment(params,sales_order)
          shop_ownership(params,sales_order)
          parteners(params,sales_order)
          biz(params,sales_order)
          industries(params,sales_order)
          competitions(params,sales_order)
        end
        rescue Exception => e
           
        end

    @image = Picture.new(picture: params[:left_wall_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:shop_front_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:right_wall_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:ceiling],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:flooring],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:inside_out_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:outside_in_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:complete_shop_building_view],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:left_shops],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:right_shop],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:opposite_foot_shop],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:catchment_picture],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:prominent_mobile],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
    @image = Picture.new(picture: params[:experience_shop],object_type: 'SalesOrder',:object_id => sales_order.id)      
    @image.save
  
  end

  def self.shop_dimensions(params,sales_order)
    shop = JSON.parse(params[:shop_dimensions_attributes])
    shop_dimension = ShopDimension.new(super_build_up_area: shop['super_build_up_area'],
         built_up_area: shop['built_up_area'],
         carpet_area: shop['carpet_area'],
         clear_height: shop['clear_height'], 
         seepage: shop['no_seepage'],
         mezzanine_floor: shop['no_mezzanine_floor'],
         hindrance: shop['hindrance'],
         power_backup: shop['power_back_up'],
         current_flooring: shop['current_flooring'],
         current_ceilling: shop['current_ceiling'],
         current_wall_status: shop['current_walls_status'],
         fire_safety: shop['fire_safety'],
         gsb_opportunity: shop['gsb_opportunity'],
         special_visible_opportunity: shop['visiblity_opprtunity'],
         other_issue: shop['branding_issue'],
         sales_order_id: sales_order.id
        )
        
        #if shop_dimension['super_build_up_area'] != '' && shop_dimension['build_up_area'] !='' && shop_dimension['carpet_area'] != '' && shop_dimension['clear_height'] != '' && shop_dimension['seepage'] != 'Enter No Seepage' && shop_dimension['mezzanine_floor'] != 'Enter No Mezzanine floor ' && shop_dimension['hindrance'] != 'Enter Please confirm no hindrance' && shop_dimension['power_backup'] != 'Enter Power Back Up & Load' && shop_dimension['current_flooring'] != '' && shop_dimension['current_ceilling'] != '' && shop_dimension['current_wall_status'] != '' && shop_dimension['fire_safety'] != 'Enter Fire safety' && shop_dimension['gsb_opportunity'] != '' && shop_dimension['special_visible_opportunity'] != '' && shop_dimension['other_issue'] != '' 
            shop_dimension.save
        #end
  end 

  def self.catchment(params,sales_order)
    catchment = JSON.parse(params[:catchments_attributes])
    catchments = Catchment.new(introduction: catchment['introduction'],
        population: catchment['population'],
        colonies: catchment['colonies_covered'],
        brand_stores: catchment['Mobile_Brand_stores'],
        consumer_stores: catchment['consumer_electronics_Store'],
        rsp_counters: catchment['no_of_rsp'],
        sis_counters: catchment['no_of_sis'],  
        sales_order_id: sales_order.id
          )
       
        if catchments.save      
           catchment_business = []
           catchment_business_shops_attributes = {}

           JSON.parse(params[:catchment_business_shops_attributes]).each do |value|
            catchment_business_shops_attributes = CatchmentBusinessShop.new(left: value['left'],
            right:  value['right'],
            opposite: value['opposite'],
            catchment_id: catchments.id)
           catchment_business_shops_attributes.save
          end 
        end
  end

  def self.shop_ownership(params,sales_order)
    shop_owner = JSON.parse(params[:shop_ownerships_attributes])
    shop_ownership = ShopOwnership.new(
          shop_type: shop_owner['ownership_type'],
          title: shop_owner['title_of_ownership'],
          clear_title_duration: shop_owner['duration'],
          parking_available: shop_owner['parking_available'],
          hindrance_entrance: shop_owner['no_hindrance'],
          sales_order_id: sales_order.id
        )
        shop_ownership.save 
  end

  def self.parteners(params,sales_order)
    parteners = []
        parteners_attributes = {}
        JSON.parse(params[:parteners_attributes]).each do |value|
          parteners_attributes = Partener.new(
            structure: value['structure'],
            ownership: value['ownership'],
            nature: value['nature'],
            turnover: value['turnover'],
            man_power: value['man_power'],
            partener_name: value['partener_name'],
            breif_intro: value['breif_intro'],
            sales_order_id: sales_order.id
            ) 

          parteners_attributes.save
        end        
  end

  def self.biz(params,sales_order)
    JSON.parse(params[:rev_months_attributes]).each do |key,value|
       
          rev_months_attributes = Biz.new(
            title: key,
            month1: value[0],
            month2: value[1],
            month3: value[2],
            month4: value[3],
            month5: value[4],
            month6: value[5],
            month7: value[6],
            month8: value[7],
            month9: value[8],                                  
            month10: value[9],
            month11: value[10],
            month12: value[11],
            sales_order_id: sales_order.id
            )
          rev_months_attributes.save           
        end
  end

  def self.industries(params,sales_order)
    industries_attributes = JSON.parse(params[:industry_attributes])
        mainKeys = industries_attributes.keys     
        mainKeys.each do |mainKey|
          compValue = industries_attributes[mainKey]
          childKeys = compValue.keys
          childKeys.each do |childKey|
            @industry = Industry.new(
                name: childKey,
                value: compValue[childKey]['value'],
                volume: compValue[childKey]['volume'],
                comp_name: mainKey,
                sales_order_id: sales_order.id
              )
            @industry.save
          end
        end
  end

  def self.competitions(params,sales_order)
    competitions_attributes = JSON.parse(params[:competitions_attributes])
        mainKeys = competitions_attributes.keys
        mainKeys.each do |mainKey|
          compValue = competitions_attributes[mainKey]
          childKeys = compValue.keys
          childKeys.each do |childKey|
            @competition = Competition.new(
              name: childKey,
              comp_name: mainKey,
              comp_value: compValue[childKey],
              sales_order_id: sales_order.id
              )
            @competition.save
          end
        end
  end 


  def self.permit_branding_shops(current_user)
     state_ids = State.states(current_user)
     where(state_id: state_ids)
  end

  def self.download(id)

      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => 'Project Analysis'
      sheet2 = book.create_worksheet :name => 'Biz Analysis'
       
      ########sheet 1 ####### 
       sheet1.row(0).height = 30
      format = Spreadsheet::Format.new  :color => :green, :weight => :bold, :size => 18
      
      sheet1.row(0).default_format = format
      
      sheet1.row(0).concat %w{BrandStore}

     
      @sales = SalesOrder.select("id","name","email","phone").find(id)
       
      [0,1].each{|col| sheet1.column(col).width = 25}
       
      index = 1

      sales = @sales.attributes.map { |v|  v }
      sales.delete(sales.first)

      sales.each do |o|
            sheet1.row(index).push  o.first, o.last
            index += 1 
      end 

      sheet1.row(4).height = 30       
      sheet1.row(4).default_format = format
      sheet1.row(4).concat %w{ShopDimension}
      index+= 1


      shop_dimension = @sales.shop_dimension.attributes.map{|v| v}
      shop_dimension.delete(shop_dimension.first)
      shop_dimension.delete(shop_dimension[14])

      shop_dimension.each do |o|

            sheet1.row(index).push  o.first, o.last
            index += 1 
      end 

      sheet1.row(20).height = 30       
      sheet1.row(20).default_format = format
      sheet1.row(20).concat %w{CatchmentAnalsysis}
      index+= 1
  
      catchment = @sales.catchment.attributes.map{|v| v}    
      catchment.delete(catchment.first)
      catchment.delete(catchment[7])

       catchment.each do |o|
            sheet1.row(index).push  o.first, o.last
            index += 1 
      end

      sheet1.row(28).height = 30       
      sheet1.row(28).default_format = format
      sheet1.row(28).concat %w{Business}
      index+= 1

      catchment_business = @sales.catchment.catchment_business_shops.map{|v| v.attributes.select{|k,i| k if(k != "id")}.select{|j,l| j if j != "catchment_id"}}
       
      catchment_business.each do |o|
          o.each do |data|
            sheet1.row(index).push  data.first, data.last
            index += 1
          end 
      end
      
      index+=1
      sheet1.row(index).height = 30       
      sheet1.row(index).default_format = format
      sheet1.row(index).concat %w{ShopOwnership}
      index+= 1

      shop_ownership = @sales.shop_ownership.attributes.map{|v| v}   
      shop_ownership.delete(shop_ownership.first)
      shop_ownership.delete(shop_ownership[5])

      shop_ownership.each do |o|
            sheet1.row(index).push  o.first, o.last
            index += 1 
      end
      index+=1
      sheet1.row(index).height = 30       
      sheet1.row(index).default_format = format
      sheet1.row(index).concat %w{PartnerAnalysis}
      index+= 1

      partener = @sales.parteners.map{|v| v.attributes.select{|k,i| k if(k != "id")}.select{|j,l| j if j != "sales_order_id"} }
      
      
      partener.each do |o|
          o.each do |data|
            sheet1.row(index).push  data.first, data.last
            index += 1
          end 
      end

      index+=1
      sheet1.row(index).height = 20       
      sheet1.row(index).default_format = format
      sales = SalesOrder.find(id)
      

      sheet1.row(index).concat %w{Status  }
      sheet1.row(index).push sales.status
       index+=1
      sheet1.row(index).height = 20       
      sheet1.row(index).default_format = format
      sheet1.row(index).concat %w{Comment  }
      sheet1.row(index).push sales.comment

      ##########sheet 2 ##########
      

      [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].each{|col| sheet2.column(col).width = 30}
       
     sheet2.row(0).height = 30
      format = Spreadsheet::Format.new  :color => :green, :weight => :bold, :size => 18
      
      sheet2.row(0).default_format = format
      
      sheet2.row(0).concat %w{EBITDAProjectionfornext1yearofOperation}
      
      biz = @sales.bizs.reverse.map{|v| v.attributes.select{|k| k if(k != "id")}.select{|j| j if(j != "created_at")}.select{|j| j if(j != "updated_at")}.select{|j| j if(j != "sales_order_id")} }
        
      values = SalesOrder.rest_Values(@sales.bizs)
      total_Avg = SalesOrder.total_value_for_model(@sales.bizs)

      final_array = []
      data = []
      new_data = []
       
      biz.each do |bizData|
         data << bizData.to_a.flatten
      end
      
      data.each_with_index do |bizs,index|
        new_data << bizs.select.with_index { |_, index| index.odd? }
      end
      
      data = []
      data[0] = new_data[0]
      data[0].insert(13,total_Avg[:result].map(&:to_s)[0])
      data[0].insert(14,total_Avg[:avg].map(&:to_s)[0])
      
      data[1] =  new_data[1]
      data[1].insert(13,total_Avg[:result].map(&:to_s)[1])
      data[1].insert(14,total_Avg[:avg].map(&:to_s)[1])
      
      data[2] = values[:gross].map(&:to_s)
      data[2].insert(0, 'gross')
      data[2].insert(13,total_Avg[:result].map(&:to_s)[2])
      data[2].insert(14,total_Avg[:avg].map(&:to_s)[2])
      
      data[3] = new_data[2]
      data[3].insert(13,total_Avg[:result].map(&:to_s)[3])
      data[3].insert(14,total_Avg[:avg].map(&:to_s)[3]) 
      
      data[4] = new_data[3]
      data[4].insert(13,total_Avg[:result].map(&:to_s)[4])
      data[4].insert(14,total_Avg[:avg].map(&:to_s)[4]) 
      
      data[5] = new_data[4]
      data[5].insert(13,total_Avg[:result].map(&:to_s)[5])
      data[5].insert(14,total_Avg[:avg].map(&:to_s)[5]) 
      
      data[6] = new_data[5]
      data[6].insert(13,total_Avg[:result].map(&:to_s)[6])
      data[6].insert(14,total_Avg[:avg].map(&:to_s)[6]) 
      
      data[7] = new_data[6]
      data[7].insert(13,total_Avg[:result].map(&:to_s)[7])
      data[7].insert(14,total_Avg[:avg].map(&:to_s)[7]) 
      
      data[8] = new_data[7]
      data[8].insert(13,total_Avg[:result].map(&:to_s)[8])
      data[8].insert(14,total_Avg[:avg].map(&:to_s)[8])
      
      data[9] = new_data[8]
      data[9].insert(13,total_Avg[:result].map(&:to_s)[9])
      data[9].insert(14,total_Avg[:avg].map(&:to_s)[9]) 
      
      data[10] = new_data[9]
      data[10].insert(13,total_Avg[:result].map(&:to_s)[10])
      data[10].insert(14,total_Avg[:avg].map(&:to_s)[10])  
      
      data[11] = values[:total_overhead].map(&:to_s)
      data[11].insert(0, 'total_overhead')
      data[11].insert(13,total_Avg[:result].map(&:to_s)[11])
      data[11].insert(14,total_Avg[:avg].map(&:to_s)[11])
      
      data[12] = values[:ebt_profit].map(&:to_s)
      data[12].insert(0, 'ebt_profit')
      data[12].insert(13,total_Avg[:result].map(&:to_s)[12])
      data[12].insert(14,total_Avg[:avg].map(&:to_s)[12])

      
      data[13] = values[:edt_margin_percentage].map(&:to_s)
      data[13].insert(0, 'edt_margin_percentage')
      data[13].insert(13,total_Avg[:result].map(&:to_s)[13])
      data[13].insert(14,total_Avg[:avg].map(&:to_s)[13])

      data[14] = new_data[10]
      data[14].insert(13,total_Avg[:result].map(&:to_s)[14])
      data[14].insert(14,total_Avg[:avg].map(&:to_s)[14])
      
      data[15] = new_data[11] 
      data[15].insert(13,total_Avg[:result].map(&:to_s)[15])
      data[15].insert(14,total_Avg[:avg].map(&:to_s)[15])
      
      data[16] = new_data[12]
      data[16].insert(13,total_Avg[:result].map(&:to_s)[16])
      data[16].insert(14,total_Avg[:avg].map(&:to_s)[16])

     
      sheet2.row(1).concat %w{name month1 month2 month3 month4 month5 month6 month7 month8 month9 month10
        month11 month12 Total Average}

      data.reverse.each do |o|
         o = o.to_a.flatten
         sheet2.insert_row(2, o)
      end
      
      sheet2.row(19).height = 30
      format = Spreadsheet::Format.new  :color => :green, :weight => :bold, :size => 18
      
      sheet2.row(19).default_format = format
      
      sheet2.row(19).concat %w{IndustryAnalysis}
      
      industry = @sales.industries.reverse.map{|v| v.attributes.select{|k| k if(k != "id")}.select{|j| j if(j != "sales_order_id")}.select{|j| j if(j != "comp_name")}.select{|j| j if(j != "comp_value")} }
        
      count = 0
      industry_array = []
      industry.each do |o|
         o = o.to_a.flatten
        industry_array << o.select.with_index { |_, index| index.odd? }
      end
      industry_array.reverse.each do |o|
        count+=1
         sheet2.insert_row(20, o)
      end

     
       count+= 1
       sheet2.row(19+count).height = 30
       sheet2.row(19+count).default_format = format
      
      sheet2.row(19+count).concat %w{CompetitionAnalysis}
      

       competition = @sales.competitions.reverse.map{|v| v.attributes.select{|k| k if(k != "id")}.select{|j| j if(j != "sales_order_id")} } 

       competition_array = []
      competition.each do |o|
         o = o.to_a.flatten
          competition_array << o.select.with_index { |_, index| index.odd? }
        
      end

      competition_array.each do |o|
        count+=1
         sheet2.insert_row(19+count+1, o)
      end
     
        name = 'brandstoreproposal_'+   @sales.id.to_s
      book.write "#{Rails.root}/public/brand_store/#{name}.xls" 
  end


  def self.rest_Values(bizData)
    finalVal = {}
    
    revenueData = []
    marginData = []
    man_powerData = []
    electricData = []
    rental_costData = []
    houseData = []
    internetData = []
    hardwareData = []
    stationeryData = []
    overheadData = []

    gross = []
    total_overhead = []
     ebt_profit = []
     

    bizData.reverse.each_with_index do |biz,index|
       
      if index == 0  
        revenueData.push(biz.attributes.values[2..13])
      elsif  index == 1    
        marginData.push(biz.attributes.values[2..13])
      elsif index == 2
        man_powerData.push(biz.attributes.values[2..13])
      elsif index == 3
        electricData.push(biz.attributes.values[2..13])
      elsif index == 4
        rental_costData.push(biz.attributes.values[2..13])
      elsif index == 5
        houseData.push(biz.attributes.values[2..13])
      elsif index == 6
        internetData.push(biz.attributes.values[2..13])
      elsif index == 7
        hardwareData.push(biz.attributes.values[2..13])
      elsif index == 8
        stationeryData.push(biz.attributes.values[2..13])
      elsif index == 9
        overheadData.push(biz.attributes.values[2..13])
       
      end
    end
    revenueData = revenueData.flatten.map(&:to_i)
    marginData = marginData.flatten.map(&:to_i)

    man_powerData = man_powerData.flatten.map(&:to_i)
    electricData = electricData.flatten.map(&:to_i)
    rental_costData = rental_costData.flatten.map(&:to_i)
    houseData = houseData.flatten.map(&:to_i)
    internetData = internetData.flatten.map(&:to_i)
    hardwareData = hardwareData.flatten.map(&:to_i)
    stationeryData = stationeryData.flatten.map(&:to_i)
    overheadData = overheadData.flatten.map(&:to_i)
         

    for i in 0..11
        gross << revenueData[i]*marginData[i]
     end

    for i in 0..11
      total_overhead << man_powerData[i]+electricData[i]  +rental_costData[i] +houseData[i] + internetData[i] + hardwareData[i] + stationeryData[i] + overheadData[i]
    end


     gross.each_with_index do |val, index| ebt_profit << val-total_overhead[index] end
    
      ebt_profit = ebt_profit[0..11]
      

      edt_margin_percentage = []

       
      gross.each_with_index do |val, index| ebt_profit << val-total_overhead[index] end

    
      
        ebt_profit[0..11].each_with_index do |val,index|
            if revenueData[index] == 0
              edt_margin_percentage << 0
            else
              edt_margin_percentage << val / revenueData[index]
            end
        end
             
       final = {}
       final[:gross] = gross
       final[:total_overhead] = total_overhead
       final[:ebt_profit] = ebt_profit[0..11]
       final[:edt_margin_percentage] = edt_margin_percentage
       final

   end

  def self.total_value_for_model(bizData)

    finalVal = {}
    
    revenueData = []
    marginData = []
    man_powerData = []
    electricData = []
    rental_costData = []
    houseData = []
    internetData = []
    hardwareData = []
    stationeryData = []
    overheadData = []

    skudata = []
    volumndata = []
    valuedata = []

    gross = []
    total_overhead = []
    new_revenueData = []
    
    bizData.reverse.each_with_index do |biz,index|
       
      if index == 0  
        revenueData.push(biz.attributes.values[2..13])
      elsif  index == 1    
        marginData.push(biz.attributes.values[2..13])
      elsif index == 2
        man_powerData.push(biz.attributes.values[2..13])
      elsif index == 3
        electricData.push(biz.attributes.values[2..13])
      elsif index == 4
        rental_costData.push(biz.attributes.values[2..13])
      elsif index == 5
        houseData.push(biz.attributes.values[2..13])
      elsif index == 6
        internetData.push(biz.attributes.values[2..13])
      elsif index == 7
        hardwareData.push(biz.attributes.values[2..13])
      elsif index == 8
        stationeryData.push(biz.attributes.values[2..13])
      elsif index == 9
        overheadData.push(biz.attributes.values[2..13])
      elsif index == 10
        skudata.push(biz.attributes.values[2..13])
      elsif index == 11
        volumndata.push(biz.attributes.values[2..13])
      elsif index == 12
        valuedata.push(biz.attributes.values[2..13])
       
      end


    end

    result = []
    avg = []

   revenueData = revenueData.flatten.map(&:to_i)
   result.push(revenueData.inject{|sum, n| sum + n })
   avg.push(result[0]/12)



   marginData = marginData.flatten.map(&:to_i)
   result.push(marginData.inject{|sum, n| sum + n })
   avg.push(result[1]/12)

   
    for i in 0..11
      gross << revenueData[i]*marginData[i]
    end
    
    
    result.push(gross.inject{|sum, n| sum + n })
    avg.push(result[2]/12)

    

    man_powerData = man_powerData.flatten.map(&:to_i)
    result.push(man_powerData.inject{|sum, n| sum + n })
    avg.push(result[3]/12)



    electricData = electricData.flatten.map(&:to_i)
   result.push(electricData.inject{|sum, n| sum + n })
     avg.push(result[4]/12)


    rental_costData = rental_costData.flatten.map(&:to_i)
   result.push(rental_costData.inject{|sum, n| sum + n })
     avg.push(result[5]/12)



    houseData = houseData.flatten.map(&:to_i)
   result.push(houseData.inject{|sum, n| sum + n })
      avg.push(result[6]/12)




    internetData = internetData.flatten.map(&:to_i)
  result.push(internetData.inject{|sum, n| sum + n })
     avg.push(result[7]/12)



    hardwareData = hardwareData.flatten.map(&:to_i)
    result.push(hardwareData.inject{|sum, n| sum + n })
     avg.push(result[8]/12)


    stationeryData = stationeryData.flatten.map(&:to_i)
    result.push(stationeryData.inject{|sum, n| sum + n })
     avg.push(result[9]/12)




    overheadData = overheadData.flatten.map(&:to_i)
    result.push(overheadData.inject{|sum, n| sum + n })
     avg.push(result[10]/12)



    for i in 0..11
      total_overhead << man_powerData[i]+electricData[i]  +rental_costData[i] +houseData[i] + internetData[i] + hardwareData[i] + stationeryData[i] + overheadData[i]
    end

    result.push(total_overhead.inject{|sum, n| sum + n })
    avg.push(result[11]/12)

    #calculating sum and avg of gross and overhead
       ebt_profit = []
     gross.each_with_index do |val, index| ebt_profit << val-total_overhead[index] end
     result.push(ebt_profit.inject{|sum, n| sum + n })
      avg.push(result[12]/12)

      edt_margin_percentage = []

       gross.each_with_index do |val, index| ebt_profit << val-total_overhead[index] end

    
      
        ebt_profit[0..11].each_with_index do |val,index|
            if revenueData[index] == 0
              edt_margin_percentage << 0
            else
              edt_margin_percentage << val / revenueData[index]
            end
        end
        result.push(edt_margin_percentage.inject{|sum, n| sum + n })
        avg.push(result[13]/12)
     

      
   skudata = skudata.flatten.map(&:to_i)
    result.push(skudata.inject{|sum, n| sum + n })
      avg.push(result[14]/12)
   
   volumndata = volumndata.flatten.map(&:to_i)
    result.push(volumndata.inject{|sum, n| sum + n })
      avg.push(result[15]/12)

   valuedata = valuedata.flatten.map(&:to_i)
    result.push(valuedata.inject{|sum, n| sum + n })
      avg.push(result[16]/12)

      finalVal[:result] = result
      finalVal[:avg] =  avg
    
      finalVal

  end



  def self.total_value(bizData)
    
    finalVal = {}
    
    revenueData = []
    marginData = []
    man_powerData = []
    electricData = []
    rental_costData = []
    houseData = []
    internetData = []
    hardwareData = []
    stationeryData = []
    overheadData = []

    skudata = []
    volumndata = []
    valuedata = []

    gross = []
    total_overhead = []
    new_revenueData = []
    
    bizData.reverse.each_with_index do |biz,index|
       
      if index == 0  
        revenueData.push(biz.attributes.values[2..13])
      elsif  index == 1    
        marginData.push(biz.attributes.values[2..13])
      elsif index == 2
        man_powerData.push(biz.attributes.values[2..13])
      elsif index == 3
        electricData.push(biz.attributes.values[2..13])
      elsif index == 4
        rental_costData.push(biz.attributes.values[2..13])
      elsif index == 5
        houseData.push(biz.attributes.values[2..13])
      elsif index == 6
        internetData.push(biz.attributes.values[2..13])
      elsif index == 7
        hardwareData.push(biz.attributes.values[2..13])
      elsif index == 8
        stationeryData.push(biz.attributes.values[2..13])
      elsif index == 9
        overheadData.push(biz.attributes.values[2..13])
      elsif index == 10
        skudata.push(biz.attributes.values[2..13])
      elsif index == 11
        volumndata.push(biz.attributes.values[2..13])
      elsif index == 12
        valuedata.push(biz.attributes.values[2..13])
       
      end


    end

    result = []
    avg = []

    other_value = []
    other_avg  = []

   revenueData = revenueData.flatten.map(&:to_i)
   result.push(revenueData.inject{|sum, n| sum + n })
   avg.push(result[0]/12)



   marginData = marginData.flatten.map(&:to_i)
   result.push(marginData.inject{|sum, n| sum + n })
   avg.push(result[1]/12)

   
    for i in 0..11
      gross << revenueData[i]*marginData[i]
    end
    
    
    other_value.push(gross.inject{|sum, n| sum + n })
    other_avg.push(other_value[0]/12)

    

    man_powerData = man_powerData.flatten.map(&:to_i)
    other_value.push(man_powerData.inject{|sum, n| sum + n })
    other_avg.push(other_value[1]/12)


    electricData = electricData.flatten.map(&:to_i)
   result.push(electricData.inject{|sum, n| sum + n })
     avg.push(result[2]/12)


    rental_costData = rental_costData.flatten.map(&:to_i)
   result.push(rental_costData.inject{|sum, n| sum + n })
     avg.push(result[3]/12)



    houseData = houseData.flatten.map(&:to_i)
   result.push(houseData.inject{|sum, n| sum + n })
      avg.push(result[4]/12)




    internetData = internetData.flatten.map(&:to_i)
  result.push(internetData.inject{|sum, n| sum + n })
     avg.push(result[5]/12)



    hardwareData = hardwareData.flatten.map(&:to_i)
    result.push(hardwareData.inject{|sum, n| sum + n })
     avg.push(result[6]/12)


    stationeryData = stationeryData.flatten.map(&:to_i)
    result.push(stationeryData.inject{|sum, n| sum + n })
     avg.push(result[7]/12)




    overheadData = overheadData.flatten.map(&:to_i)
    result.push(overheadData.inject{|sum, n| sum + n })
     avg.push(result[8]/12)



    for i in 0..11
      total_overhead << man_powerData[i]+electricData[i]  +rental_costData[i] +houseData[i] + internetData[i] + hardwareData[i] + stationeryData[i] + overheadData[i]
    end

    other_value.push(total_overhead.inject{|sum, n| sum + n })
    other_avg.push(other_value[2]/12)

    #calculating sum and avg of gross and overhead
       ebt_profit = []
     gross.each_with_index do |val, index| ebt_profit << val-total_overhead[index] end
     other_value.push(ebt_profit.inject{|sum, n| sum + n })
      other_avg.push(other_value[3]/12)
     

   
    
   skudata = skudata.flatten.map(&:to_i)
    other_value.push(skudata.inject{|sum, n| sum + n })
      other_avg.push(other_value[4]/12)
   
   volumndata = volumndata.flatten.map(&:to_i)
    result.push(volumndata.inject{|sum, n| sum + n })
      avg.push(result[9]/12)

   valuedata = valuedata.flatten.map(&:to_i)
    result.push(valuedata.inject{|sum, n| sum + n })
      avg.push(result[10]/12)

      
      finalVal[:result] = result
      finalVal[:avg] =  avg
      finalVal[:other_value]= other_value
      finalVal[:other_avg] = other_avg
      finalVal
   


   
  end

  def self.autoCalculateValues(bizData)
    finalVal = {}
    
    revenueData = []
    marginData = []
    man_powerData = []
    electricData = []
    rental_costData = []
    houseData = []
    internetData = []
    hardwareData = []
    stationeryData = []
    overheadData = []

    gross = []
    total_overhead = []
    new_revenueData = []
    
    bizData.reverse.each_with_index do |biz,index|
       
      if index == 0  
        revenueData.push(biz.attributes.values[2..13])
      elsif  index == 1    
        marginData.push(biz.attributes.values[2..13])
      elsif index == 2
        man_powerData.push(biz.attributes.values[2..13])
      elsif index == 3
        electricData.push(biz.attributes.values[2..13])
      elsif index == 4
        rental_costData.push(biz.attributes.values[2..13])
      elsif index == 5
        houseData.push(biz.attributes.values[2..13])
      elsif index == 6
        internetData.push(biz.attributes.values[2..13])
      elsif index == 7
        hardwareData.push(biz.attributes.values[2..13])
      elsif index == 8
        stationeryData.push(biz.attributes.values[2..13])
      elsif index == 9
        overheadData.push(biz.attributes.values[2..13])
      end
    end
   
   revenueData = revenueData.flatten.map(&:to_i)
   marginData = marginData.flatten.map(&:to_i)
   
   man_powerData = man_powerData.flatten.map(&:to_i)
   electricData = electricData.flatten.map(&:to_i)
   rental_costData = rental_costData.flatten.map(&:to_i)
   houseData = houseData.flatten.map(&:to_i)
   internetData = internetData.flatten.map(&:to_i)
   hardwareData = hardwareData.flatten.map(&:to_i)
   stationeryData = stationeryData.flatten.map(&:to_i)
   overheadData = overheadData.flatten.map(&:to_i)

   new_revenueData = revenueData
    
   


    for i in 0..11
      gross << revenueData[i].to_i*marginData[i].to_i
    end
 
    for i in 0..11
      total_overhead << man_powerData[i]+electricData[i]  +rental_costData[i] +houseData[i] + internetData[i] + hardwareData[i] + stationeryData[i] + overheadData[i]
    end

 
   finalVal[:gross] = gross
   finalVal[:total_overhead] = total_overhead
   finalVal[:new_revenueData] = new_revenueData
   finalVal

  end


end
   
