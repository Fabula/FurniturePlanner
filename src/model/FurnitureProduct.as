package model
{
	import alternativa.engine3d.objects.Mesh;
	
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	import vo.FurnitureModelVO;
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
		
		public var furnitureModel:FurnitureModel;
		public var modelMesh:Mesh;
		
		public function FurnitureProduct(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String,
										 furnitureCategory:String, price:Number, model:FurnitureModel, description:String, furnitureProductID:int = 0)
		{
			this.furnitureProductID = furnitureProductID;
			this.manufacturerName = manufacturerName;
			this.manufacturerCountry = manufacturerCountry;
			this.furnitureStyle = furnitureStyle;
			this.furnitureCategory = furnitureCategory;
			this.price = price;
			this.furnitureModel = model;
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
			furnitureProductVO.description = this.description;
			
			var modelVO:FurnitureModelVO = new FurnitureModelVO();
			modelVO.height = this.furnitureModel.height;
			//modelVO.height = this.model.height;
			modelVO.width = this.furnitureModel.width;
			modelVO.length = this.furnitureModel.length;
			
			
			// encode bytearray to string
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(this.furnitureModel.furnitureModel);
			
			modelVO.model = encoder.toString();
			
			furnitureProductVO.model = modelVO;

			return furnitureProductVO;
		}
		
		public static function fromVO(productVO:FurnitureProductVO):FurnitureProduct{
			// преобразуем base64 строку в byteArray
			var decoder:Base64Decoder = new Base64Decoder();
			var furnitureModel:ByteArray;
			
			decoder.decode(productVO.model.model);
			furnitureModel = decoder.toByteArray();
			
			var fmodel:FurnitureModel = new FurnitureModel(furnitureModel, productVO.model.height, productVO.model.width, productVO.model.length);
			
			var furnitureProduct:FurnitureProduct = new FurnitureProduct(productVO.manufacturer_name, productVO.manufacturer_country,
														productVO.style_name, productVO.furniture_category_name,
														productVO.price, fmodel, productVO.description, productVO.id);
			return furnitureProduct;
		}
	}
}