package ru.inspirit.utils
{

	public class ArrayUtils {

		public static function addAt(arr:Array, index:Number, value:*):void
		{
			arr.splice(index, 0, value);
		}

		public static function removeAt(arr:Array, index:Number):void
		{
			if(index == 0){
				arr.shift();
			} else if(index == (arr.length-1)){
				arr.pop();
			} else if(index > 0 && index < (arr.length-1) ){
				arr.splice(index, 1);
			}
		}

		public static function getUniqueValues(_arr:Array):Array
		{
			var obj:Object = {};
			var i:int = _arr.length;
			var arr:Array = new Array();
			var t:*;
			while (i--) {
				t = _arr[i];
				obj[t] = t;
			}
			for (t in obj) {
				arr.push(obj[t]);
			}
			return arr;
		}

		public static function chooseRandom(arr:Array):*
		{
			return (arr[Math.floor(Math.random() * arr.length)]);
		}

		/**
		 * Clones an array.
		 *
		 * @param array the array to clone
		 * @return a clone of the passed-in {@code array}
		 */
		public static function clone(array:Array):Array
		{
			return array.concat();
		}

		/**
		 * Removes the given {@code element} out of the passed-in {@code array}.
		 *
		 * @param array the array to remove the element out of
		 * @param element the element to remove
		 * @return {@code true} if {@code element} was removed and {@code false} if it was
		 * not contained in the passed-in {@code array}
		 */
		public static function removeElement(array:Array, element:*):Array
		{
			return removeAllOccurances(array, element);
		}


		/**
		 * Removes all occurances of a the given {@code element} out of the passed-in
		 * {@code array}.
		 *
		 * @param array the array to remove the element out of
		 * @param element the element to remove
		 * @return List that contains the index of all removed occurances
		 */
		public static function removeAllOccurances(array:Array, element:*):Array
		{
			var i:int = array.length;
			var found:Array = new Array();
			while (--i-(-1)) {
				if (array[i] === element) {
					found.unshift(i);
					array.splice(i, 1);
				}
			}
			return found;
		}

		/**
		 * Removes the last occurance of the given {@code element} out of the passed-in
		 * {@code array}.
		 *
		 * @param array the array to remove the element out of
		 * @param element the element to remove
		 * @return {@code -1} if it could not be found, else the position where it had been deleted
		 */
		public static function removeLastOccurance(array:Array, element:*):int
		{
			var i:int = array.length;
			while(--i-(-1)) {
				if(array[i] === element) {
					array.splice(i, 1);
					return i;
				}
			}
			return -1;
		}

		/**
		 * Removes the first occurance of the given {@code element} out of the passed-in
		 * {@code array}.
		 *
		 * @param array the array to remove the element out of
		 * @param element the element to remove
		 * @return {@code -1} if it could not be found, else the position where it had been deleted
		 */
		public static function removeFirstOccurance(array:Array, element:*):int
		{
			var l:int = array.length;
			var i:int = 0;
			while(i<l) {
				if (array[i] === element) {
					array.splice(i, 1);
					return i;
				}
				i-=-1;
			}
			return -1;
		}

		/**
		 * Checks if the passed-in {@code array} contains the given {@code object}.
		 *
		 * <p>The content is searched through with a for..in loop. This enables any type of
		 * array to be passed-in, indexed and associative arrays.
		 *
		 * @param array the array that may contain the {@code object}
		 * @param object the object that may be contained in the {@code array}
		 * @return {@code true} if the {@code array} contains the {@code object} else
		 * {@code false}
		 */
		public static function contains(array:Array, object:*):Boolean
		{
			var i:int = array.length;
			while (--i > -1) {
				if (array[i] == object) {
					return true;
				}
			}
			/*
			for (var i: in array) {
				if (array[i] == object) {
					return true;
				}
			}
			*/
			return false;
		}

		/**
		 * Returns the index of first occurance of the given {@code object} within
		 * the passed-in {@code array}.
		 *
		 * <p>The content of the {@code array} is searched through by iterating through the
		 * array. This method returns the first occurence of the passed-in {@code object}
		 * within the {@code array}. If the object could not be found {@code -1} will be
		 * returned.
		 *
		 * @param array the array to search through
		 * @param object the object to return the position of
		 * @return the position of the {@code object} within the {@code array} or {@code -1}
		 */
		public static function indexOf(array:Array, object:*):int
		{
			for (var i:Number=0; i < array.length; i++) {
				if (array[i] === object) {
					return i;
				}
			}
			return -1;
		}

		/**
		 * Returns the index of the last occurance of the given {@code object} within
		 * the passed-in {@code array}.
		 *
		 * <p>The content of the {@code array} is searched through by iterating through the
		 * array. This method returns the last occurence of the passed-in {@code object}
		 * within the {@code array}. If the object could not be found {@code -1} will be
		 * returned.
		 *
		 * @param array the array to search through
		 * @param object the object to return the position of
		 * @return the position of the {@code object} within the {@code array} or {@code -1}
		 */
		public static function lastIndexOf(array:Array, object:*):int
		{
		    var i:Number = array.length;
			while (--i-(-1)) {
				if (array[i] === object) {
					return i;
				}
			}
			return -1;
		}

		/**
		 * Shuffles the passed-in {@code array}.
		 *
		 * @param array the array to shuffle
		 */
		public static function shuffle(array:Array):void
		{
			var len:Number = array.length;
			var rand:Number;
			var temp:*;
			for (var i:Number = len-1; i >= 0; i--){
				rand = Math.floor(Math.random()*len);
				temp = array[i];
				array[i] = array[rand];
				array[rand] = temp;
			}
		}


		/**
		 * Swaps the value at position {@code i} with the value at position {@code j} of the
		 * passed-in {@code array}.
		 *
		 * <p>The modifications are directly made to the passed-in {@code array}.
		 *
		 * @param array the array whose elements to swap
		 * @param i the index of the first value
		 * @param j the index of the second value
		 * @return array the passed-in {@code array}
		 * @throws IllegalArgumentException if the argument {@code array} is {@code null}
		 * @throws NoSuchElementException if the passed-in positions {@code i} and {@code j}
		 * are less than 0 or greater than the array's length
		 */
		public static function swap(array:Array, i:int, j:int):Array
		{
			if (array.length == 0) {
				trace("Array to swap content has to be available");
				return array;
			}
			if (i > array.length-1 || i < 0) {
				trace("The first index "+i+" is not available within the array");
				return array;
			}
			if (j > array.length-1 || j < 0) {
				trace("The second index "+j+" is not available within the array");
				return array;
			}
			var tmp:* = array[i];
			array[i] = array[j];
			array[j] = tmp;
			return array;
		}

		/**
		 * Compares the two arrays {@code array1} and {@code array2}, whether they contain
		 * the same values at the same positions.
		 *
		 * @param array1 the first array for the comparison
		 * @param array2 the second array for the comparison
		 * @return {@code true} if the two arrays contain the same values at the same
		 * positions else {@code false}
		 */
		public static function isSame(array1:Array, array2:Array):Boolean
		{
			var i:Number = array1.length;
			if (i != array2.length) {
				return false;
			}
			while (--i-(-1)) {
				if (array1[i] !== array2[i]) {
					return false;
				}
			}
			return true;
		}

		public static function traceArray(arr:Array, nameStr:String):String
		{
			var _local3:String = "";
			var _local1:int = 0;
			while (_local1 < arr.length) {
				if (typeof (arr[_local1]) == "object") {
					_local3 = _local3 + (((nameStr + "[") + _local1) + "] = new Array();\n");
					_local3 = _local3 + ArrayUtils.traceArray(arr[_local1], ((nameStr + "[") + _local1) + "]");
				} else {
					_local3 = _local3 + (((((nameStr + "[") + _local1) + "] = \"") + arr[_local1].toString()) + "\";\n");
				}
				_local1++;
			}
			return (_local3);
		}
		
	}
}