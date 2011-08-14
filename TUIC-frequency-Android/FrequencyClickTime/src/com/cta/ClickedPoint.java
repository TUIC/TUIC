package com.cta;

import java.util.ArrayList;

public class ClickedPoint {
	ArrayList<Pointer> list = new ArrayList<Pointer>();

	void add(Pointer inP) {

		if (list.size() == 0) {
			list.add(inP);
		} else {
			boolean flag = true;
			// 清除不要的紀錄
			while (flag) {
				flag = false;
				for (Pointer p : list) {
					if (inP.startTime - p.startTime > 1000) {
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

	int getPoint(long inTime, float inX, float inY) {
		// 回傳此座標附近的點擊次數
		int r = 0;
		for (Pointer p : list) {

			if (((p.x - inX) * (p.x - inX) + (p.y - inY) * (p.y - inY)) < 1000
					&& inTime - p.startTime <= 1000) {
				r = p.clickCnt;
				break;
			}
		}

		return r + 1;
	}
}
