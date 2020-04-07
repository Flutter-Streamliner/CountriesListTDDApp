import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:countries_ttd/features/countries_list/presentation/bloc/country_bloc.dart';
import 'package:countries_ttd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
      ),
      body: BlocProvider(
        create: (_) => serviceLocator<CountryBloc>(),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state){
        if (state is CountryInitialState) {
          return InitialWidget();
        } else if (state is CountryLoadingState) {
          return LoadingWidget();
        } else if (state is CountryLoadedState) {
          return CountriesListWidget(countries: state.countries);
        } else if (state is CountryErrorState) {
          return ErrorWidget(message: state.message);
        } else {
          return ErrorWidget(message: 'Unexpected error');
        }
      },
    );
  }
}

class InitialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('show countries'),
        onPressed: (){
          BlocProvider.of<CountryBloc>(context).add(GetAllCountriesEvent());
        },
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CountriesListWidget extends StatelessWidget {
  final List<CountryModel> countries;

  CountriesListWidget({@required this.countries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Text('${countries[index].name} ${countries[index].code}'),
        );
      } 
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;

  ErrorWidget({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}