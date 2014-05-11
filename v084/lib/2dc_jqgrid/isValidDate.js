
function isValidDate(value, colname)
{                                       
      var isValid = true;
      var formatYmd = "";
      if(value=~/(\:)(d2)(\:)/)
        {formatYmd = "Y/m/d H:i";}
       else
         {formatYmd = "Y/m/d";}
      try{
          jQuery.datepicker.parseDate(formatYmd, value, null);
          }
      catch(error){
                   isValid = false;
                   return [isValid,"Please enter　valid date"];
                  }
      return [isValid,""];
}   
