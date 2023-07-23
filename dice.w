bring cloud;
bring http;
bring math;
bring ex;

struct DiceServiceOptions {
  chanceOfFailure: num?; /** rate of simulated failure for the service */
}

class DiceService {
  url: str; /** the url of the dice service */

  init(opts: DiceServiceOptions?) {
    let api = new cloud.Api();
    this.url = api.url;

    let errorResponse = inflight (status: num, message: str): cloud.ApiResponse => {
      return cloud.ApiResponse {
        status: status,
        headers: { "content-type" => "application/json" },
        body: Json.stringify({ error: message }),
      };
    };
      
    api.post("/rolls", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
      DiceService.simulateFailure(opts?.chanceOfFailure);

      if !req.query.has("name") {
        return errorResponse(400, "Query parameter 'name' is required");
      }
    
      let name = req.query.get("name");
      if !(name.length >= 2 && name.length <= 30) {
        return errorResponse(400, "Query parameter 'name' must be between 2 and 30 characters");
      }
    
      let diceRoll = math.floor(math.random(6)) + 1;
      log("${name}=${diceRoll}");

      return cloud.ApiResponse {
        status: 200,
        headers: { "content-type" => "application/json" },
        body: Json.stringify({ 
          name: name,
          diceRoll: diceRoll
        })
      };
    });
  }

  static inflight simulateFailure(chanceOfFailure: num?) {
    let rate = chanceOfFailure ?? 0;

    // random sample between 0 to 100
    let sample = math.random(100);

    // if rate == 0 then we never fail, if rate == 100 we always fail
    if sample < rate {
      throw("simulated failure");
    }
  }
}
