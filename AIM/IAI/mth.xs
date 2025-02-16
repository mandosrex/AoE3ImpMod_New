//math

//==============================================================================
// MIN
// updatedOn 2020/10/15 By ageekhere
//==============================================================================
float MIN(float a = 0.0, float b = 0.0)
{ //returns the lowest value between two values 
	 debugRule("float MIN " + a + " " + b,0);
	if (a < b) return (a); // a is lower
	return (b); //b is lower
} //end MIN

//==============================================================================
// MAX
// updatedOn 2020/10/15 By ageekhere
//==============================================================================
float MAX(float a = 0.0, float b = 0.0)
{ //returns the largest value between two values 
	debugRule("float MAX " + a + " " + b, 0);
	if (a < b) return (b);
	return (a);
} //end MAX

//==============================================================================
// distance
// updatedOn 2020/10/28 By ageekhere
//==============================================================================
float distance(vector v1 = cInvalidVector, vector v2 = cInvalidVector)
{ // Will return a float with the 3D distance between two vectors 
	//debugRule("float distance ",0);
	return (xsVectorLength(v1 - v2));
} //end distance

//==============================================================================
/* sigmoid(float base, float adjustment, float floor, float ceiling)
	
	Used to adjust a number up or down in a sigmoid fashion, so that it
	grows very slowly at values near the bottom of the range, quickly near
	the center, and slowly near the upper limit.  
	
	Used with the many 0..1 range variables, this lets us adjust them up
	or down by arbitrary "percentages" while retaining the 0..1 boundaries.  
	That is, a 50% "boost" (1.5 adjustment) to a .9 score gives .933, while a

	Base is the number to be adjusted.
	Adjustment of 1.0 means 100%, i.e. stay where you are.
	Adjustment of 2.0 means to move it up by the LESSER movement of:
	Doubling the (base-floor) amount, or
	Cutting the (ceiling-base) in half (mul by 1/2.0).
	
	With a default floor of 0 and ceiling of 1, it gives these results:
	sigmoid(.1, 2.0) = .2
	sigmoid(.333, 2.0) = .667, upper and lower adjustments equal
	sigmoid(.8, 2.0) = .9, adjusted up 50% (1/2.0) of the headroom.
	sigmoid(.1, 5.0) = .50 (5x base, rather than moving up to .82)
	sigmoid(.333, 5.0) = .866, (leaving 1/5 of the .667 headroom)
	sigmoid(.8, 5.0) = .96 (leaving 1/5 of the .20 headroom)
	
	Adjustments of less than 1.0 (neutral) do the opposite...they move the 
	value DOWN by the lesser movement of:
	Increasing headroom by a factor of 1/adjustment, or
	Decreasing footroom by multiplying by adjustment.
	sigmoid(.1, .5) = .05   (footroom*adjustment)
	sigmoid(.667, .5) = .333  (footroom*adjustment) = (headroom doubled)
	sigmoid(.8, .2) = .16 (footroom*0.2)
	
	Not intended for base < 0.  Ceiling must be > floor.  Must have floor <= base <= ceiling.
*/
//==============================================================================
float sigmoid(float base = -1.0 /*required*/ , float adjust = 1.0, float floor = 0.0, float ceiling = 1.0)
{
	float retVal = -1.0;
	if (base < 0.0) return (retVal);
	if (ceiling <= floor) return (retVal);
	if (base < floor) return (retVal);
	if (base > ceiling) return (retVal);
	float footroom = base - floor;
	float headroom = ceiling - base;
	float footBasedNewValue = 0.0; // This will be the value created by adjusting the footroom, i.e.
	// increasing a small value.
	float headBasedNewValue = 0.0; // This will be the value created by adjusting the headroom, i.e.
	// increasing a value that's closer to ceiling than floor.
	if (adjust > 1.0)
	{ // Increasing
		footBasedNewValue = floor + (footroom * adjust);
		headBasedNewValue = ceiling - (headroom / adjust);
		// Pick the value that resulted in the smaller net movement
		if ((footBasedNewValue - base) < (headBasedNewValue - base))
			retVal = footBasedNewValue; // The foot adjustment gave the smaller move.
		else
			retVal = headBasedNewValue; // The head adjustment gave the smaller move
	}
	else
	{ // Decreasing
		footBasedNewValue = floor + (footroom * adjust);
		headBasedNewValue = ceiling - (headroom / adjust);
		// Pick the value that resulted in the smaller net movement
		if ((base - footBasedNewValue) < (base - headBasedNewValue))
			retVal = footBasedNewValue; // The foot adjustment gave the smaller move.
		else
			retVal = headBasedNewValue; // The head adjustment gave the smaller move
	}
	//aiEcho("sigmoid("+base+", "+adjust+", "+floor+", "+ceiling+") is "+retVal);
	return (retVal);
}

//==============================================================================
/*
	Military Manager
	
	Create maintain plans for military unit lines.  Control 'maintain' levels,
	buy upgrades.  
*/
//==============================================================================
float armyRatio(int value = 0)
{
	if (value < 20)
	{
		return (0.13);
	}
	else if (value < 25)
	{
		return (0.16);
	}
	else if (value < 30)
	{
		return (0.19);
	}
	else if (value < 35)
	{
		return (0.22);
	}
	else if (value < 40)
	{
		return (0.25);
	}
	else if (value < 45)
	{
		return (0.28);
	}
	else if (value < 50)
	{
		return (0.31);
	}
	else if (value < 55)
	{
		return (0.34);
	}
	else if (value < 60)
	{
		return (0.37);
	}
	else
	{
		return (0.4);
	}
	return (0.0);
}


