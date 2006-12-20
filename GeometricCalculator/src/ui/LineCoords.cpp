#include "../model/Point.h"
#include "../model/Line.h"
#include "LineCoords.h"

LineCoords::LineCoords(PointPtr start, PointPtr end) {
	const Coordinates startCoords = start->coordinates();
	myXStart = startCoords.x;
	myYStart = startCoords.y;

	const Coordinates endCoords = end->coordinates();
	myXEnd = endCoords.x;
	myYEnd = endCoords.y;
}

LineCoords::LineCoords(LinePtr line, const int width, const int height) {
	const Coordinates startCoords = line->point(START)->coordinates();
	myXStart = startCoords.x;
	myYStart = startCoords.y;

	const Coordinates endCoords = line->point(END)->coordinates();
	myXEnd = endCoords.x;
	myYEnd = endCoords.y;

	if ((myXStart == myXEnd) && (myYStart == myYEnd)) {
		return;
	}

	if (line->kind() == SEGMENT) {
		return;
	} else if (line->kind() == LINE) {
		if (myXStart == myXEnd) {
			myYStart = 0;
			myYEnd = height;
		} else if (myYStart == myYEnd) {
			myXStart = 0;
			myXEnd = width;
		} else {
			double x0 = 0;
			double y0 = myYStart + (myYStart - myYEnd) * (x0 - myXStart) / (myXStart - myXEnd);
			if ((y0 < 0) || (y0 > height)) {
				y0 = (y0 < 0) ? 0 : height;
			  x0 = myXStart + (myXStart - myXEnd) * (y0 - myYStart) / (myYStart - myYEnd);
			}

			double x1 = width;
			double y1 = myYStart + (myYStart - myYEnd) * (x1 - myXStart) / (myXStart - myXEnd);
			if ((y1 < 0) || (y1 > height)) {
				y1 = (y1 < 0) ? 0 : height;
			  x1 = myXStart + (myXStart - myXEnd) * (y1 - myYStart) / (myYStart - myYEnd);
			}

			myXStart = x0;
			myXEnd = x1;
			myYStart = y0;
			myYEnd = y1;
		}
	} else if (line->kind() == HALFLINE) {
		if (myXStart == myXEnd) {
			myYEnd = (myYStart > myYEnd) ? 0 : height;
		} else if (myYStart == myYEnd) {
			myXEnd = (myXStart > myXEnd) ? 0 : width;
		} else {
			double x = (myXStart > myXEnd) ? 0 : width;
			double y = myYStart + (myYStart - myYEnd) * (x - myXStart) / (myXStart - myXEnd);
			if ((y < 0) || (y > height)) {
				y = (y < 0) ? 0 : height;
			  x = myXStart + (myXStart - myXEnd) * (y - myYStart) / (myYStart - myYEnd);
			}
			myXEnd = x;
			myYEnd = y;
		}
	}
}

const int LineCoords::XStart() const {
	return (int)(myXStart + .5);
}

const int LineCoords::YStart() const {
	return (int)(myYStart + .5);
}

const int LineCoords::XEnd() const {
	return (int)(myXEnd + .5);
}

const int LineCoords::YEnd() const {
	return (int)(myYEnd + .5);
}
