package com.cta;

import java.util.ArrayList;

import android.util.Log;

public class ClickedPoint {
	ArrayList<Pointer> list = new ArrayList<Pointer>();

	void add(Pointer inP) {

		if (list.size() == 0) {
			list.add(inP);
		} else {
			boolean flag = true;
			// 清除不要的紀錄
			long now = System.currentTimeMillis();
			while (flag) {
				flag = false;

				for (Pointer p : list) {
					if (now - p.startTime > 1000) {
						flag = true;
						list.remove(p);
						break;
					}

					if (((p.x - inP.x) * (p.x - inP.x) + (p.y - inP.y)
							* (p.y - inP.y)) < 1000) {
						flag = true;
						list.remove(p);

						break;
					}
				}

			}
			// 將放開的點加入紀錄
			list.add(inP);

		}

	}

	Pointer getPoint(float inX, float inY) {

		Pointer r = null;
		Long now = System.currentTimeMillis();
		for (Pointer p : list) {

			if (((p.x - inX) * (p.x - inX) + (p.y - inY) * (p.y - inY)) < 1000
					&& now - p.startTime <= 1000) {
				r = new Pointer(p);
				break;
			}
		}

		return r;
	}
}
