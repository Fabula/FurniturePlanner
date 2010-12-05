package model
{
	import alternativa.engine3d.objects.Mesh;
	
	import vo.FurnitureProductVO;

	[Bindable]
	public class FurnitureProduct
	{
		public var furnitureProductID:int;
		public var manufacturerName:String;
		public var manufacturerCountry:String;
		public var furnitureStyle:String;
		public var furnitureCategory:String;
		public var price:Number;
		public var description:String;
		//base 64Encode
		public var model_data:String;
		public var modelMesh:Mesh;
		
		public function FurnitureProduct(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String,
										 furnitureCategory:String, price:Number, model_data:String, description:String, furnitureProductID:int = 0)
		{
			this.furnitureProductID = furnitureProductID;
			this.manufacturerName = manufacturerName;
			this.manufacturerCountry = manufacturerCountry;
			this.furnitureStyle = furnitureStyle;
			this.furnitureCategory = furnitureCategory;
			this.price = price;
			this.model_data = model_data;
			this.description = description;
		}
		
		public function toVO():FurnitureProductVO{
			var furnitureProductVO:FurnitureProductVO = new FurnitureProductVO();
			furnitureProductVO.id = this.furnitureProductID;
			furnitureProductVO.manufacturer_name = this.manufacturerName;
			furnitureProductVO.manufacturer_country = this.manufacturerCountry;
			furnitureProductVO.style_name = this.furnitureStyle;
			furnitureProductVO.furniture_category_name = this.furnitureCategory;
			furnitureProductVO.price = this.price;
			furnitureProductVO.model = this.model_data;
			furnitureProductVO.description = this.description;
			
			return furnitureProductVO;
		}
		
		public static function fromVO(productVO:FurnitureProductVO):FurnitureProduct{
			var furnitureProduct:FurnitureProduct = new FurnitureProduct(productVO.manufacturer_name, productVO.manufacturer_country,
														productVO.style_name, productVO.furniture_category_name,
														productVO.price, productVO.model,  productVO.description, productVO.id);
			return furnitureProduct;
		}
	}
}