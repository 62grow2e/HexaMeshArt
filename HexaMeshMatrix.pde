public class HexaMeshMatrix {

	private PVector vertexes[][];
	private PVector vertexes_base[][];
	private PVector vertexes_honeycomb[][];
	private PVector vertexGroup[][];
	private PVector vertexDiffs[][];

	private int num_hexagonHorizontal;
	private int num_hexagonVertical;

	private int num_hVertex;
	private int num_vVertex;
	private int num_hexagon;

	private float len_pass;
	private float hexaWidth;
	private float hexaHeight;

	private PVector wholeSize;

	private color fillColor[];
	private int strokeWidth = 10;

	private float noiseScale = 30;
	private float noiseCount = 0;

	private float diffAmp = 10;

	private boolean bAutoScale = false;
	private PVector scalePower = new PVector(1, 1, 0);

	public HexaMeshMatrix (int num_horizontal, int num_vertical) {
		len_pass = 30;

		num_hexagonHorizontal = num_horizontal;
		num_hexagonVertical = num_vertical;

		num_hVertex = num_hexagonHorizontal*2+1;
		num_vVertex = num_hexagonVertical+1;
		num_hexagon = num_hexagonHorizontal*num_hexagonVertical-num_hexagonVertical/2;

		hexaWidth = len_pass*sqrt(3);
		hexaHeight = 2*len_pass;

		wholeSize = new PVector(hexaWidth*(num_hexagonHorizontal-2), 3*hexaHeight/4*(num_hexagonVertical-2)+hexaHeight/4);

		vertexes = new PVector[num_hVertex][num_vVertex];
		vertexes_base = new PVector[num_hVertex][num_vVertex];
		vertexes_honeycomb = new PVector[num_hVertex][num_vVertex];
		vertexGroup = new PVector[num_hexagon][6];
		vertexDiffs = new PVector[num_hVertex][num_vVertex];

		initDiffs();
		//updateDiffs();
		plotVertexes();
		shiftVertexes();
		groupingVertexes();

		fillColor = new color[num_hexagon];
		changeColor();

	}

	private void groupingVertexes() {
		int groupCount = 0;
		for(int i = 0; i < num_hVertex; i+=2){
			for(int j = 0; j < num_vVertex-1; j++){
				if(groupCount>num_hexagon-1)continue;
				if(j%2 == 0){
					vertexGroup[groupCount][0] = new PVector(i, j, 0);
					vertexGroup[groupCount][1] = new PVector(i+1, j, 0);
					vertexGroup[groupCount][2] = new PVector(i+2, j, 0);
					vertexGroup[groupCount][3] = new PVector(i+2, j+1, 0);
					vertexGroup[groupCount][4] = new PVector(i+1, j+1, 0);
					vertexGroup[groupCount][5] = new PVector(i, j+1, 0);

					groupCount++;
				}
				else if(j%2 == 1){
					if(i+3 > num_hVertex-1)continue;
					vertexGroup[groupCount][0] = new PVector(i+1, j, 0);
					vertexGroup[groupCount][1] = new PVector(i+2, j, 0);
					vertexGroup[groupCount][2] = new PVector(i+3, j, 0);
					vertexGroup[groupCount][3] = new PVector(i+3, j+1, 0);
					vertexGroup[groupCount][4] = new PVector(i+2, j+1, 0);
					vertexGroup[groupCount][5] = new PVector(i+1, j+1, 0);

					groupCount++;
				}
				//println("groupCount: "+groupCount);
			}
		}
		//println(vertexGroup[i]);
	}

	private void initDiffs() {
		for(int i = 0; i < num_hVertex; i++){
			for(int j = 0; j < num_vVertex; j++){
				vertexDiffs[i][j] = new PVector(0, 0);
			}
		}
	}
	private void updateDiffs() {
		for(int i = 0; i < num_hVertex; i++){
			for(int j = 0; j < num_vVertex; j++){
				vertexDiffs[i][j].set(random(-diffAmp, diffAmp), random(-diffAmp, diffAmp));
			}
		}
	}
	private void shiftVertexes(){
		for(int i = 0; i < num_hVertex; i++){
			for(int j = 0; j < num_vVertex; j++){
				//if(j%2 == 1 && i+3 > num_hVertex-1)continue;
				PVector base = vertexes_base[i][j];
				PVector honey = vertexes_honeycomb[i][j];
				PVector diff = vertexDiffs[i][j];
				base.x = honey.x + diff.x;
				base.y = honey.y + diff.y;
				//vertexes_base[i][j].add(vertexDiffs[i][j]);
			}
		}
	}

	private void plotVertexes() {
		for(int i = 0; i < num_hVertex; i++){
			for(int j = 0; j < num_vVertex; j++){
				float px = i*hexaWidth/2;
				float py = 0;
				if(j%2 == 0){
					if(i%2 == 0)py = j*3*hexaHeight/4+hexaHeight/4;
					else if(i%2 == 1)py = j*3*hexaHeight/4;
				}
				else if (j%2 == 1){
					if(i%2 == 0)py = j*3*hexaHeight/4;
					else if(i%2 == 1)py = j*3*hexaHeight/4+hexaHeight/4;
				}
				vertexes[i][j] = new PVector(px, py);
				vertexes_base[i][j] = new PVector(px, py);
				vertexes_honeycomb[i][j] = new PVector(px, py);
			}
		}
	}

	public void draw(float window_x, float window_y) {
		strokeWeight(strokeWidth);
		stroke(255);
		strokeJoin(ROUND);

		pushMatrix();
		if(bAutoScale){
			translate(scalePower.x*wholeSize.x/window_x/2, scalePower.y*wholeSize.y/window_y/2);
			scale(scalePower.x, scalePower.y);
			translate(-window_x/wholeSize.x/2, -window_y/wholeSize.y/2);
		}
		scale(window_x/wholeSize.x, window_y/wholeSize.y);
		translate(-hexaWidth, -hexaHeight);

		for(int i = 0; i < num_hexagon; i++){
			PVector group[] = vertexGroup[i];
			fill(fillColor[i]);
			beginShape();
			for(int j = 0; j < 6; j++){
				PVector ver1 = vertexes[(int)group[j].x][(int)group[j].y];
				PVector ver2 = vertexes[(int)group[(j+1)%6].x][(int)group[(j+1)%6].y];
				vertex(ver1.x, ver1.y, ver2.x, ver2.y);
			}
			endShape(CLOSE); 
		}
		popMatrix();
	}

	public void perlinNoiseVertex() {
		noiseCount += .02;
		for(int i = 0; i < num_hVertex; i++){
			for(int j = 0; j < num_vVertex; j++){
				PVector v = vertexes[i][j];
				PVector v_base = vertexes_base[i][j];
				v.x = noiseScale*noise(noiseCount+v_base.y)+v_base.x;
				v.y = noiseScale*noise(noiseCount+v_base.x)+v_base.y;
			}
		}
	}
	public void setScalePower(float pow_x, float pow_y) {
		scalePower.set(pow_x, pow_y);
	}
	public void enableAutoScale() {
		bAutoScale = true;
	}
	public void disdiableAutoScale() {
		bAutoScale = false;
	}
	public void setStrokeWidth(int w) {
		strokeWidth = w;
	}
	public void changeColor() {
		for(int i = 0; i < num_hexagon; i++){
			int rnd = (int)random(6);
			switch (rnd) {
				case 0 :
				default :	
					fillColor[i] = color(#ff0000);
				break;
				case 1 :
					fillColor[i] = color(#00ff00);
				break;
				case 2 :
					fillColor[i] = color(#0000ff);
				break;	
				case 3 :
					fillColor[i] = color(#ffff00);
				break;	
				case 4 :
					fillColor[i] = color(#00ffff);
				break;
				case 5 :
					fillColor[i] = color(#ff00ff);
				break;	
			}
		}
		
	}
}