#ifndef _functions_cpp
#define _functions_cpp

float roundNumberOnTwoFigures (float number)
{
    int numberAsIntTimesHundred = number*100;
    float roundedNumber = numberAsIntTimesHundred / 100.0;
    return roundedNumber;
}

#endif