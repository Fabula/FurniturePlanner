package business.room
{
	import alternativa.engine3d.core.MipMapping;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	
	import flash.display.BitmapData;
	
	public class Room extends Box
	{
		[Embed(source="textures/wood-floorboards-texture.jpg")] 
		private const EmbedFloorTexture:Class;
		
		[Embed(source="textures/bricks_zigzag_texture.jpg")]
		private const EmbedWallTexture:Class;
		
		[Embed(source="textures/celling.jpg")]
		private const EmbedCellingTexture:Class;
		
		// создание материалов
		private var floorBitmap:BitmapData = new EmbedFloorTexture().bitmapData;
		private var floorTexture:TextureMaterial = new TextureMaterial(floorBitmap, false, true, MipMapping.NONE);
		
		private var wallBitmap:BitmapData = new EmbedWallTexture().bitmapData;
		private var wallTexture:TextureMaterial = new TextureMaterial(wallBitmap);
		
		private var cellingBitmap:BitmapData = new EmbedCellingTexture().bitmapData;
		private var cellingTexture:TextureMaterial = new TextureMaterial(cellingBitmap);
		
		public var width:Number;
		public var length:Number;
		public var height:Number;
		
		public function Room(width:Number, length:Number, height:Number)
		{
			super(width, length, height, 1,1,1, true, false, 
				wallTexture, wallTexture, wallTexture, wallTexture, floorTexture, cellingTexture);
			
			this.width = width;
			this.length = length;
			this.height = height;
			
		}
		
	}
}