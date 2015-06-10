HexaMeshMatrix mesh;
void setup(){
	size(displayWidth, displayHeight, P2D);
	//size(1600, 900, P2D);
	mesh = new HexaMeshMatrix(15, 10);
	//mesh.setNoiseScale(50);
	mesh.setStrokeWidth(5);
	mesh.enableAutoScale();
	//mesh.setScalePower(2, 2);
	//mesh.shiftVertex();
}

boolean perlinNoise = false;
float t = 0;
void draw(){
	//background(0);
	//println("scale", mesh.scale);
	if(perlinNoise)mesh.perlinNoiseVertex();
	mesh.setScalePower(.25*sin(t)+1.25,.25*sin(t)+1.25);
	mesh.draw(width, height);
	t += 0.01;
}
void keyPressed(){
	if(key == ' '){
		mesh.updateDiffs();
		mesh.shiftVertexes();
	}
	else if(keyCode == SHIFT){
		mesh.shiftVertexes();
	}
	else if(key == 'c'){
		mesh.changeColor();
	}
	else if(key == 'p')perlinNoise = !perlinNoise;
}