import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:car_manufac/car_mfr.dart';

class CarManufac extends StatefulWidget {
  const CarManufac({super.key});

  @override
  State<CarManufac> createState() => _CarManufacState();
}

class _CarManufacState extends State<CarManufac> {
  CarMfr? carMfr;

  Future<CarMfr?> getCarMfr() async {
    var url = "vpic.nhtsa.dot.gov";

    var uri = Uri.https(url, "/api/vehicles/getallmanufacturers", {"format": "json"});
    await Future.delayed(const Duration(seconds: 3)); // Mock delay
    var response = await get(uri);

    carMfr = carMfrFromJson(response.body);
    return carMfr;
  }

  @override
  void initState() {
    super.initState();
    getCarMfr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Manufacturers"),
      ),
      body: FutureBuilder<CarMfr?>(
        future: getCarMfr(),
        builder: (BuildContext context, AsyncSnapshot<CarMfr?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            var results = snapshot.data!.results!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var result = results[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(result.mfrId.toString()),
                  ),
                  title: Text(result.mfrName ?? "Unknown Manufacturer"),
                  subtitle: Text("Country: ${result.country ?? "Unknown"}"),
                );
              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
