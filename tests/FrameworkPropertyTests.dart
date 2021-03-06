//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* Tests related to the FrameworkProperty model */
class FrameworkPropertyTests extends TestGroupBase 
{

  void registerTests(){
    this.testGroupName = "FrameworkProperty Tests";
    
    testList["resolve 1st level property"] = resolveFirstLevelProperty;
    testList["resolve nth level property"] = resolveNthLevelProperty;
    testList["resolve fails on property not found"] = resolveFailOnPropertyNotFound;
    testList["resolve fail on orphan properties"] = resolveFailOnOrphanProperties;
    testList["resolve is case in-sensitive"] = resolveIsCaseInSensitive;
  }
  
  void resolveFirstLevelProperty(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    var result = b.resolveProperty("background");
    Expect.isTrue(result.value is SolidColorBrush);
  }
  
  void resolveNthLevelProperty(){
    Border b1 = new Border();
    Border b2 = new Border();
    Border b3 = new Border();
    Border b4 = new Border();
    b1.content = b2;
    b2.content = b3;
    b3.content = b4;
    
    //set some properties
    b3.width = 45;
    b4.height = 26;
    
    //get the background from the deepest nested border
    var result = b1.resolveProperty("content.content.content.height");
    Expect.equals(26, result.value);
    
    //get the width from the 2nd nested border (b3)
    var result2 = b1.resolveProperty("content.content.width");
    Expect.equals(45, result2.value);
  }
  
  void resolveFailOnPropertyNotFound(){
    Border b = new Border();
    
    Expect.throws(
    ()=> b.resolveProperty("foo"),
    (err)=> (err is FrameworkPropertyResolutionException)
    );
  }
  
  void resolveIsCaseInSensitive(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    var result = b.resolveProperty("BaCkGrOuNd");
    Expect.isTrue(result.value is SolidColorBrush);
  }
  
  void resolveFailOnOrphanProperties(){
    Border b = new Border();
    b.background = new SolidColorBrush(new Color.predefined(Colors.Red));
    
    Expect.throws(
    ()=> b.resolveProperty("background.foo"),
    (err)=> (err is FrameworkPropertyResolutionException)
    );
  }
  
}
