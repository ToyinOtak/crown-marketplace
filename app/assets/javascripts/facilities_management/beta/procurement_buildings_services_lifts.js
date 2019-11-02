// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function LiftDataUI(jqContainer) {
    this.containerDiv = jqContainer;
    this.liftDataContainer = jqContainer.find(".liftdata");
}
LiftDataUI.prototype.addNewLift = function() {
    // get the current number of lifts
    let currentCount = Number(this.liftDataContainer.find("div[data-propertyname='Lift Data']").length);
    let newInputElement = $("<div>", {
        "class": "govuk-form-group",
        "data-propertyname":"Lift Data",
        "data-liftcount":currentCount+1,
    }).append([
        $("<label>",{"class":"govuk-label", "for":"newlift_"+(currentCount+1)}).append("Lift " + (currentCount+1) + "."),
        $("<span>",{"class":"govuk-caption-m"}).append("Number of floors"),
        $("<input>",{"class":"govuk-input govuk-input--width-2", "type":"number","min":"1","max":"99","required":"required",
                     "id":"newlift_"+(currentCount+1),
                     "name":"facilities_management_procurement_building_service[lift_data][]"}),
        $("<button>",{"class":"govuk-!-margin-left-2 govuk-button govuk-button--secondary removelift",
                      "data-liftcount":(currentCount+1)}).append("Remove")
    ]);
    newInputElement.find("button").on('click', function(e) {
        e.preventDefault();
        let targetLift = Number(e.currentTarget.getAttribute("data-liftcount"));
        this.removeLift(targetLift);
    }.bind(this));
    this.liftDataContainer.find("button[data-liftcount=" + currentCount + "]").addClass("govuk-visually-hidden");
    this.liftDataContainer.append(newInputElement);
};

LiftDataUI.prototype.removeLift = function(nLiftIndex) {
    let toRemove = this.liftDataContainer.find("div[data-liftcount=" + nLiftIndex + "]");
    toRemove.remove();
    this.liftDataContainer.find("button[data-liftcount=" + (nLiftIndex-1) + "]").removeClass("govuk-visually-hidden");
};

LiftDataUI.prototype.connectButtons = function() {
    if (this.containerDiv) {
        let addNewButton = this.containerDiv.find(".addliftbtn");
        if ( addNewButton.length > 0 ) {
            addNewButton.on('click', function(e){
                e.preventDefault();
                this.addNewLift();
            }.bind(this));
        }
    }
    if ( this.liftDataContainer){
        let removeButtons = this.liftDataContainer.find(".removelift");
        if ( removeButtons.length > 0 ) {
            removeButtons.on('click', function(e) {
                e.preventDefault();
                let targetLift = Number(e.currentTarget.getAttribute("data-liftcount"));
                this.removeLift(targetLift);
            }.bind(this));
        }
    }
};
$(function(){
   let liftDataContainer = $(".liftdatacontainer");
   if (liftDataContainer.length > 0 ) {
       this.liftHelper = new LiftDataUI(liftDataContainer);
       this.liftHelper.connectButtons();
   }
});