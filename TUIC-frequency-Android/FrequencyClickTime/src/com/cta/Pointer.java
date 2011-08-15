package com.cta;

import java.util.ArrayList;

import android.util.Log;

public class Pointer {
	int id;
	int clickCnt;
	int clickPre;
	int windowsize = 5;
	int showHz;
	float x;
	float y;
	float pressure;
	float size;
	boolean exist;
	boolean clicked;
	ArrayList<Long> upTime = new ArrayList<Long>();
	ArrayList<Float> hz = new ArrayList<Float>();
	int hzCnt;
	float nowHz;
	long startTime;

	Pointer() {
		exist = false;
		clicked = false;
		pressure = 0;
		size = 0;
		startTime = System.currentTimeMillis();

	}

	Pointer(Pointer p) {
		if (p != null) {
			clickCnt = p.clickCnt;
			x = p.x;
			y = p.y;
			startTime = System.currentTimeMillis();
			exist = p.exist;
			upTime.addAll(p.upTime);
			hz.addAll(p.hz);
			hzCnt = p.hzCnt;
			showHz = p.showHz;
		} else {
			exist = false;
			clicked = false;
			pressure = 0;
			size = 0;
			clickCnt = 0;
			startTime = System.currentTimeMillis();

		}
	}

	void setPoint(Pointer p) {
		if (p != null) {
			clickCnt = p.clickCnt;
			hzCnt = p.hzCnt;
			x = p.x;
			y = p.y;
			startTime = System.currentTimeMillis();
			exist = p.exist;
			upTime.clear();
			upTime.addAll(p.upTime);
			hz.clear();
			hz.addAll(p.hz);
			showHz = p.showHz;
		} else {

			clickCnt = 0;
			hzCnt = 0;
			startTime = System.currentTimeMillis();
			upTime.clear();
			hz.clear();
			showHz = 0;

		}
	}

	void touchDown(int inId, float inx, float iny, float inp, float ins,
			long inTime) {
		if (!clicked) {// && inp - pressure > 0.3 ) {// && inp > 0.35) {
			// 讀取此座標附近的點擊次數
			setPoint(FrequencyClickTime.cp.getPoint(inx, iny));
			clickCnt++;

			clicked = true;
			exist = true;

		}

		// // 若壓力變小即視為放開
		// else if (inp < 0.3 && pressure - inp > 0.2 && clicked) {
		// clicked = false;
		// FrequencyClickTime.cp.add(new Pointer(this));
		// }
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
		// 紀錄up的時間
		upTime.add(new Long(System.currentTimeMillis()));

		// 計算平均點擊時間

		long t = 0;
		for (int i = 0; i < upTime.size() - 1; i++) {
			t += upTime.get(i + 1) - upTime.get(i);
		}
		nowHz = t / windowsize;
		if (upTime.size() > windowsize) {
			hz.add(new Float(t / windowsize));
			while (hz.size() > 3) {
				hz.remove(0);
			}
			// 連續三點的頻率改變時才改變
			if (hz.size() == 3) {
				int c0 = (int) ((hz.get(0) + 5) / 10);
				int c1 = (int) ((hz.get(1) + 5) / 10);
				int c2 = (int) ((hz.get(2) + 5) / 10);
				if (c0 == c1 && c0 == c2 && c0 != showHz) {
					showHz = c0;
				}
			}

		}
		while (upTime.size() > windowsize) {

			upTime.remove(0);
		}
		FrequencyClickTime.cp.add(new Pointer(this));
	}

}
