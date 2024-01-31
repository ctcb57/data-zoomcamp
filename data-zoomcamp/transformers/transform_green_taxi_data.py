if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    print(f"Preprocessing: rows with zero passengers: {data['passenger_count'].isin([0]).sum()}")
    df = data[data['passenger_count'] > 0]
    print(f"Preprocessing: rows with zero distance: {data['trip_distance'].isin([0]).sum()}")
    df = df[df['trip_distance'] > 0]
    df['lpep_pickup_date'] = df['lpep_pickup_datetime'].dt.date

    df.columns = (df.columns
                    .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                    .str.lower()
    )

    return df

@test
def test_passenger_count(output, *args) -> None:
    assert output['passenger_count'].isin([0]).sum() == 0, 'There are rides with zero passengers'

@test 
def test_trip_distance(output, *args) -> None:
    assert output['trip_distance'].isin([0]).sum() == 0, 'There are rides with no trip distance'

@test 
def test_vendor_id(output, *args) -> None:
    assert output['vendor_id'].isnull().sum() == 0, 'There are no rows without a vendor id'
