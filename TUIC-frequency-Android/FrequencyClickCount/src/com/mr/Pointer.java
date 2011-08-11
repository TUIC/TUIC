package com.mr;


public class Pointer {
	int id;
	int clickCnt;
	int clickPre;
	int hz;
	float x;
	float y;
	float pressure;
	float size;
	boolean exist;
	boolean clicked;
	long upTime;
	long startTime;

	Pointer() {
		exist = false;
		clicked = false;
		pressure = 0;
		size = 0;
		startTime = System.currentTimeMillis();
	}

	Pointer(Pointer p) {
		clickCnt = p.clickCnt;
		x = p.x;
		y = p.y;
		upTime = System.currentTimeMillis();
		startTime = p.startTime;
	}

	void touchDown(int inId, float inx, float iny, float inp, float ins,
			long inTime) {
		if (!clicked) {// && inp - pressure > 0.3 ) {// && inp > 0.35) {
			// 讀取此座標附近的點擊次數
			clickCnt = MyRowData.cp.getPoint(inTime, inx, iny);
			// 如果是第一次點則初始化
			if (clickCnt == 1) {
				startTime = System.currentTimeMillis();
				clickPre = 0;
			}
			clicked = true;
			exist = true;

		}

		// 若壓力變小即視為放開
		else if (inp < 0.3 && pressure - inp > 0.2 && clicked) {
			clicked = false;
			MyRowData.cp.add(new Pointer(this));
		}
		id = inId;
		x = inx;
		y = iny;
		pressure = inp;
		size = ins;

	}

	void touchUp() {
		exist = false;
		clicked = false;
		pressure = 0;
		size = 0;

		MyRowData.cp.add(new Pointer(this));
	}
}
