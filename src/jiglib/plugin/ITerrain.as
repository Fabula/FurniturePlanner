package jiglib.plugin
{
	/**
	 * ...
	 * @author Muzer
	 */
	public interface ITerrain
	{
		//Min of coordinate horizontally;
		function get minW():Number;
		
		//Min of coordinate vertically;
		function get minH():Number;
		
		//Max of coordinate horizontally;
		function get maxW():Number;
		
		//Max of coordinate vertically;
		function get maxH():Number;
		
		//The horizontal length of each segment;
		function get dw():Number;
		
		//The vertical length of each segment;
		function get dh():Number;
		
		//Number of segments horizontally.
		function get sw():int;
		
		//Number of segments vertically
		function get sh():int;
		
		//the heights of all vertices
		function get heights():Array;
	}

}