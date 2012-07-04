/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.interfaces
{
	import org.understandinguncertainty.personal.VariableList;
	
	public interface IPersonalisationStore
	{
		/**
		 * Load the store from some persistent memory
		 */
		function load():void;
		
		/**
		 * Save the store to persistent memory
		 */
		function save():void;
		
		/**
		 * Empty this personalisation store
		 */
		function clear():void;

		[Deprecated(replacement='Use variableList if you need a reference')]
		/**
		 * <p>Returning a reference is dangerous as it might prevent garbage collection</p>
		 * @return a reference to the list of defined variables.
		 * 
		 */
		function get variable():VariableList;
		
		/**
		 * <p>Returning a reference can be dangerous as it might prevent garbage collection</p>
		 * @return a reference to the list of defined variables.
		 * 
		 */
		function get variableList():VariableList;

		/**
		 * <p>The safe way to get a local copy of the variables.</p>
		 * @return a clone of the variableList.
		 * 
		 */
//		function get cloneVariableList():VariableList;
		
	}
}