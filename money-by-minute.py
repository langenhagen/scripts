#!/usr/bin/env python
"""Calculate, show and store the amount of money by minute."""

import datetime as dt
import decimal
import pathlib
import time


def _now() -> dt.datetime:
    """Get the current time with a second-resolution."""
    now = dt.datetime.now()
    return now.replace(microsecond=0)


def _euro(cents: float) -> decimal.Decimal:
    """Convert the given amount of cents to Euro in Decimals."""
    return decimal.Decimal(cents / 100).quantize(decimal.Decimal("1.00"))


def main():
    """Calculate the the money based on additions in a certain frequency and
    print the results to stdout and write the results to a file."""
    path = pathlib.Path.home() / ".config/money-by-minute.txt"
    with open(path, "r") as file:
        euros_per_hour = float(file.readline().strip())
        total_cents = float(file.readline().strip())

    start_time = _now()
    print(f"Total sum {_euro(total_cents)}€")
    period_in_seconds = 5
    cents_per_period = round(euros_per_hour / 60 / 60 * 100 * period_in_seconds, 2)
    euros_per_period = _euro(cents_per_period)
    sum_ = 0
    while True:
        try:
            time.sleep(period_in_seconds)
            established_time = _now() - start_time

            sum_ += cents_per_period
            total_cents += cents_per_period
            print(
                f"{established_time}  +{euros_per_period}€  =>  {_euro(sum_)}€  "
                f"=>  {_euro(total_cents)}€"
            )
        except KeyboardInterrupt:
            break

    with open(path, "w") as file:
        file.write(f"{euros_per_hour}\n")
        file.write(f"{total_cents}\n")

    print(f"Total sum {_euro(total_cents)}€")


if __name__ == "__main__":
    main()
