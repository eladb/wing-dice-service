bring "./dice.w" as dice;
bring http;
bring math;

let service = new dice.DiceService();
let failingDiceService = new dice.DiceService(chanceOfFailure: 100) as "failingDiceService";

test "DiceService - roll die" {
  let roll = (): num => {
    let response = http.post("${service.url}/rolls?name=hello");
    assert(response.ok);
    let result = Json.parse(response.body ?? "").get("diceRoll").asNum();
    return result;
  };

  // lets do 200 rolls and check the stats
  let results = MutMap<num>{};
  let samples = 300;

  for i in 0..samples {
    let dice = roll();
    let key = "${dice}";
    let curr: num? = results.get(key);
    results.set(key, (curr ?? 0) + 1);
  }

  assert(results.size() == 6);

  // 15% tolerance
  let tolerance = samples * 0.15;
  for k in results.keys() {
    let count = results.get(k);
    let avg = samples / 6;
    assert(count >= (avg - tolerance / 2));
    assert(count <= (avg + tolerance / 2));
  }
}

test "DiceService - missing name" {
  let response = http.post("${service.url}/rolls");
  assert(response.status == 400);
  assert(Json.parse(response.body ?? "").get("error").asStr() == "Query parameter 'name' is required");
}

test "DiceService - name too short" {
  let response = http.post("${service.url}/rolls?name=1");
  assert(response.status == 400);
  assert(Json.parse(response.body ?? "").get("error").asStr() == "Query parameter 'name' must be between 2 and 30 characters");
}

test "DiceService - always fails" {
  let response = http.post("${failingDiceService.url}/rolls");
  assert(!response.ok);
}

test "simulateFailure() - default is never fail" {
  for i in 0..1000 {
    dice.DiceService.simulateFailure();
  }
}

test "simulateFailure() - 50% failure" {
  let var failures = 0;
  let samples = 1000;

  for i in 0..samples {
    try {
      dice.DiceService.simulateFailure(50);
    } catch {
      failures = failures + 1;
    }
  }

  let actualRate = failures / samples * 100;
  assert(actualRate > 45 && actualRate < 55);
}