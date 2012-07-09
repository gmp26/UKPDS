/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.UKPDS.controller
{
	import org.understandinguncertainty.UKPDS.model.UserModel;
	import org.understandinguncertainty.personal.signals.ClearInterventionsSignal;

	public class SetupInterventionProfile
	{

		[Inject]
		public var user:UserModel;
	
		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		/**
		 * Reset the interventions model to be the same as the user model.
		 * Then update the interventions panel?
		 */
		public function execute():void
		{
			//trace("Moved from Profile Screen");
			inter.variableList = user.variableList.clone();
			
			clearInterventionsSignal.dispatch();
		}
	}
}