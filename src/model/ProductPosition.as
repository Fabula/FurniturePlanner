package model
{
	import flash.geom.Matrix3D;

	public class ProductPosition
	{
		public var matrix:Matrix3D;
		public var productID:int;
		// номер экземпляра предмета мебели (введен по причине того, что одна и та же мебель может быть в нескольких экземплярах)
		public var count:int;
		
		public function ProductPosition(matrix:Matrix3D, productID:int, count:int = 0)
		{
			this.matrix = matrix;
			this.productID = productID;
			this.count = count;
		}
	}
}