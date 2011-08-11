package com.cta;

public class Pointer {
	int id;
	int clickCnt;
	int clickPre;
	float hz;
	float x;
	float y;
	float pressure;
	float size;
	boolean exist;
	boolean clicked;
	long upTime[];
	int timeCnt;
	long startTime;

	Pointer() {
		exist = false;
		clicked = false;
		pressure = 0;
		size = 0;
		upTime = new long[6];
		startTime = System.currentTimeMillis();
	}

	Pointer(Pointer p) {
		clickCnt = p.clickCnt;
		x = p.x;
		y = p.y;
		startTime = p.startTime;

	}

	void touchDown(int inId, float inx, float iny, float inp, float ins,
			long inTime) {
		if (!clicked) {// && inp - pressure > 0.3 ) {// && inp > 0.35) {
			// Ū�����y�Ъ����I������
			clickCnt = FrequencyClickTime.cp.getPoint(inTime, inx, iny);
			// �p�G�O�Ĥ@���I�h��l��
			if (clickCnt == 1) {
				startTime = System.currentTimeMillis();
				clickPre = 0;
			}
			clicked = true;
			exist = true;

		}

		// �Y���O�ܤp�Y������}
		else if (inp < 0.3 && pressure - inp > 0.2 && clicked) {
			clicked = false;
			FrequencyClickTime.cp.add(new Pointer(this));
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
		// ����up���ɶ�
		upTime[timeCnt] = System.currentTimeMillis();
		timeCnt++;
		// ��up���I�ƨ����ɫh���έp
		if (timeCnt >= 6) {
			long t = 0;
			for (int i = 0; i < 5; i++) {
				t += upTime[i + 1] - upTime[i];
			}
			hz = t / 5;
			startTime = upTime[5];
			timeCnt = 0;
		}
		FrequencyClickTime.cp.add(new Pointer(this));
	}
}
