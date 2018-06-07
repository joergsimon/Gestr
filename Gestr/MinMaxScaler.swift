//
//  MinMaxScaler.swift
//  Gestr
//
//  Created by Andrea Simon on 07.02.18.
//  Copyright © 2018 Joerg Simon. All rights reserved.
//

import Foundation


class MinMaxScaler {
    
    let min = [ 1.50000000e+02, -1.00000000e+00,  0.00000000e+00, -1.00000000e+00,
                -1.00000000e+00, -1.00000000e+00, -1.00000000e+00, -1.00000000e+00,
                1.50000000e+02, -7.04096609e-01,  6.52982428e-04, -7.90099084e-01,
                -7.34167442e-01, -7.10845232e-01, -6.86345622e-01, -4.75590467e-01,
                1.50000000e+02, -8.19343168e-01,  1.55033353e-04, -8.48823726e-01,
                -8.38480726e-01, -8.28773141e-01, -8.17005396e-01, -8.09075713e-01,
                1.50000000e+02, -9.91071072e-01,  1.41523416e-04, -9.99986768e-01,
                -9.99019861e-01, -9.93405491e-01, -9.90797460e-01, -9.90621865e-01,
                1.50000000e+02, -5.44692779e-02,  1.93958278e-03, -8.28792632e-01,
                -8.07742327e-02, -3.15945596e-02, -2.02525929e-02, -4.78127599e-03,
                1.50000000e+02, -2.23906672e-02,  2.41074748e-03, -1.19890451e+00,
                -1.26424998e-01, -2.32552886e-02,  3.98069620e-04,  1.08189583e-02,
                1.50000000e+02, -2.97831539e-02,  2.38312489e-03, -7.17564106e-01,
                -1.08530596e-01, -2.75486708e-02, -1.89885050e-02,  2.04098225e-03,
                1.50000000e+02,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                1.50000000e+02,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                1.50000000e+02,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
                1.50000000e+02, -1.02988042e+00,  4.44763837e-03, -9.77691936e+00,
                -3.33413506e+00, -4.84111473e-01, -1.22444215e-02,  1.16599351e-02,
                1.50000000e+02, -6.22427402e-01,  5.50705898e-03, -5.38120747e+00,
                -1.52324808e+00, -1.75294571e-01, -3.30444816e-02,  1.18279168e-02,
                1.50000000e+02, -5.68169973e-01,  3.63789437e-03, -5.34424925e+00,
                -1.10406110e+00, -2.76190773e-01, -3.74222836e-02,  6.39736932e-03,
                1.50000000e+02, -1.55627440e+00,  6.64512882e-04, -1.56841980e+00,
                -1.56434225e+00, -1.55847774e+00, -1.55032634e+00, -1.53691701e+00,
                1.50000000e+02, -2.89293912e+00,  9.25244152e-04, -3.13811724e+00,
                -3.06170567e+00, -3.03856913e+00, -2.78010183e+00, -2.60701439e+00,
                1.50000000e+02, -1.56711845e+00,  2.37256865e-04, -3.12349269e+00,
                -2.73839080e+00, -1.91223426e+00, -1.44224876e+00, -1.20060431e+00]
    
    let range = [
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  1.05793589,
        0.40126483,  1.04266787,  0.99981155,  1.05334218,  1.21590485,
        1.20488375,  0.0       ,  1.81920024,  0.86132792,  1.84824985,
        1.83827119,  1.82869726,  1.81698456,  1.80907291,  0.0       ,
        1.21936386,  0.68151102,  1.11365174,  1.1947488 ,  1.36678211,
        1.49932528,  1.54593647,  0.0       ,  0.14951914,  0.28435005,
        0.82420731,  0.08155527,  0.08876672,  0.21724319,  1.18071988,
        0.0       ,  0.14925041,  0.29765871,  1.21422827,  0.14677781,
        0.09639785,  0.23179594,  1.87235415,  0.0       ,  0.13393593,
        0.21806132,  0.71680307,  0.11500221,  0.09202003,  0.24310499,
        0.84164524,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  0.0       ,  0.0       ,  0.0       ,  0.0       ,
        0.0       ,  2.06133725,  4.89943035,  9.76902584,  3.37616981,
        0.98170057,  3.09576609, 11.03640907,  0.0       ,  1.4048038 ,
        2.10977765,  5.37110638,  1.57454258,  0.58929496,  1.29026547,
        5.04957631,  0.0       ,  0.95013454,  1.35548154,  5.33618118,
        1.11989511,  0.46201049,  0.876889  ,  3.70248615,  0.0       ,
        2.5166649 ,  1.1555858 ,  2.51099746,  2.52054117,  2.53538943,
        2.54481555,  2.55067339,  0.0       ,  3.81957215,  1.70699676,
        3.80200792,  3.73829308,  4.09426543,  4.32302832,  5.73743797,
        0.0       ,  3.95319515,  2.52323734,  5.28744306,  5.02238173,
        4.22756646,  4.20348265,  4.33450072]
    
    func scale(data : [Double]) -> [Double] {
        let scaled = data.enumerated().map { (idx, x) -> Double in
            if range[idx] == 0.0 {
                return 1.0
            }
            let xsdt = x - min[idx] / range[idx]
            return xsdt
        }
        return scaled
    }
    
}