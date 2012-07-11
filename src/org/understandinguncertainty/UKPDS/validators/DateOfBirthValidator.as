/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.validators
{
	import mx.validators.DateValidator;
	import mx.validators.ValidationResult;
	
	public class DateOfBirthValidator extends DateValidator
	{
		
		public function DateOfBirthValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);

			if (results.length > 0)
				return results;
			
			var yyyy:int = parseInt(value.year);
			var mm:int = parseInt(value.month) - 1;
			var dd:int = parseInt(value.day);
			
			var now:Date = new Date();
			if((yyyy > now.fullYear - 15)
				|| (yyyy == now.fullYear && ( mm > now.month
					|| mm == now.month && dd > now.date))) {
				
				// Date is in the future
				results.push(new ValidationResult(
					true, "year", "futureDate",
					"too young to model risk"));
				return results;
			}
			
			if( yyyy + 95 < now.fullYear)  {
				
				// Patient is too old
				results.push(new ValidationResult(
					true, "year", "tooOld",
					"too old to model risk"));
				return results;
			}
			return results;
		}
	}
}